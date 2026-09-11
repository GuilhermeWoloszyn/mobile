import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:pdfx/pdfx.dart';

import '../data/gcp_point.dart';
import '../data/affine_geo_transform.dart';
import '../data/pdf_pixel_mapper.dart';

class TrailMapPage extends StatefulWidget {
  final String pdfAsset;
  final String geoJsonAsset;
  final double targetLat;
  final double targetLon;

  const TrailMapPage({
    super.key,
    required this.pdfAsset,
    required this.geoJsonAsset,
    required this.targetLat,
    required this.targetLon,
  });

  @override
  State<TrailMapPage> createState() => _TrailMapPageState();
}

/// Resultado de projetar um ponto (pixel) na polyline da trilha:
/// o ponto mais próximo *sobre a linha* (não só o vértice mais próximo),
/// mais um valor contínuo de "progresso" (índice do segmento + fração).
class _TrailProjection {
  final double progress; // ex: 4.35 = 35% do caminho entre o vértice 4 e o 5
  final Offset point;
  final int segmentIndex;
  final double t;

  _TrailProjection(this.progress, this.point, this.segmentIndex, this.t);
}

class _TrailMapPageState extends State<TrailMapPage> {
  static const double scale = 2.0;
  static const double _offTrailThresholdMeters = 25.0;
  static const double _arrivedThresholdMeters = 20.0;

  // Quanto mais perto do destino a câmera deve abrir, em relação ao
  // "cover" (imagem inteira). 4x costuma dar um bom equilíbrio entre
  // contexto (ver ruas ao redor) e foco no ponto.
  static const double _initialZoomFactor = 4.0;

  DateTime? _lastPositionAt;

  final TransformationController _transformController = TransformationController();
  StreamSubscription<Position>? _positionSub;

  PdfPageImage? _rendered;
  Offset? _markerPixel;
  Offset? _userPixel;

  List<Offset> _trailPixels = [];
  List<({double lat, double lon})> _trailLatLon = [];
  double _trailProgress = 0; // avança sempre; nunca volta sozinho
  double? _targetTrailProgress; // posição do destino projetada na trilha
  Offset? _nearestTrailPixel; // pra desenhar o "volte pra cá" quando fora da trilha

  bool _offTrail = false;
  double? _offTrailDistanceMeters;
  bool _arrived = false;

  String? _error;
  String? _locationNotice;
  bool _initialFitDone = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  LocationSettings _locationSettings({required bool continuous}) {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        // Usa o LocationManager nativo (GPS_PROVIDER) em vez do
        // FusedLocationProviderClient, que às vezes tenta misturar
        // Wi-Fi/rede móvel para acelerar o fix. Assim garantimos que
        // funciona 100% offline, só com sinal de satélite.
        forceLocationManager: true,
        distanceFilter: continuous ? 3 : 0,
        intervalDuration: const Duration(seconds: 2),
      );
    }
    // iOS já usa Core Location (GPS nativo) por padrão, sem depender de rede.
    return const LocationSettings(accuracy: LocationAccuracy.high);
  }

  Future<void> _load() async {
    try {
      final jsonStr = await rootBundle.loadString(widget.geoJsonAsset);
      final data = jsonDecode(jsonStr);
      final pageHeightPt = (data['pageHeightPt'] as num).toDouble();
      final gcps = (data['gcps'] as List)
          .map((e) => GcpPoint.fromJson(e as Map<String, dynamic>))
          .toList();

      final transform = AffineGeoTransform()..fit(gcps);
      if (!transform.valid) {
        setState(() => _error = 'GCPs insuficientes ou mal distribuídos.');
        return;
      }

      final mapper = PdfPixelMapper(pageHeightPt: pageHeightPt, scale: scale);

      final pdfPos = transform.geoToPdf(widget.targetLat, widget.targetLon);
      final pixel = mapper.toPixel(pdfPos.x, pdfPos.y);
      final markerPixel = Offset(pixel.x, pixel.y);

      // trilha real (pontos lat/lon extraídos do KMZ), se existir no geojson
      final trailRaw = data['trail'] as List?;
      final trailLatLon = <({double lat, double lon})>[];
      final trailPixels = <Offset>[];
      if (trailRaw != null) {
        for (final e in trailRaw) {
          final lat = (e['lat'] as num).toDouble();
          final lon = (e['lon'] as num).toDouble();
          trailLatLon.add((lat: lat, lon: lon));
          final p = transform.geoToPdf(lat, lon);
          final px = mapper.toPixel(p.x, p.y);
          trailPixels.add(Offset(px.x, px.y));
        }
      }

      final doc = await PdfDocument.openAsset(widget.pdfAsset);
      final page = await doc.getPage(1);
      final rendered = await page.render(
        width: page.width * scale,
        height: page.height * scale,
        format: PdfPageImageFormat.png,
      );
      await page.close();
      await doc.close();

      if (!mounted) return;
      setState(() {
        _rendered = rendered;
        _markerPixel = markerPixel;
        _trailPixels = trailPixels;
        _trailLatLon = trailLatLon;
      });

      // projeta o destino (tirolesa) na trilha, uma vez só: é onde o
      // trajeto "chega" antes de virar linha reta pro marcador final
      if (trailPixels.length >= 2) {
        final proj = _projectOntoTrail(markerPixel);
        _targetTrailProgress = proj?.progress;
      }

      // Localização do usuário é "melhor esforço": se falhar, o mapa
      // continua funcionando normal, só sem o marcador azul.
      await _startUserLocation(transform, mapper);
    } catch (err) {
      if (!mounted) return;
      setState(() => _error = 'Erro ao carregar o mapa: $err');
    }
  }

  Future<void> _startUserLocation(
      AffineGeoTransform transform,
      PdfPixelMapper mapper,
      ) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => _locationNotice = 'Ative o GPS para ver sua posição no mapa.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _locationNotice = 'Permissão de localização negada.');
        return;
      }

      setState(() => _locationNotice = 'Obtendo localização por GPS…');

      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        _updateUserPosition(last, transform, mapper);
      }

      try {
        final initial = await Geolocator.getCurrentPosition(
          locationSettings: _locationSettings(continuous: false),
        ).timeout(const Duration(seconds: 30));
        _updateUserPosition(initial, transform, mapper);
      } on TimeoutException {
        if (mounted && last == null) {
          setState(() => _locationNotice = 'Procurando sinal de GPS…');
        }
      }

      _listenPositionStream(transform, mapper);
    } on LocationServiceDisabledException {
      if (!mounted) return;
      setState(() => _locationNotice = 'Ative o GPS para ver sua posição no mapa.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _locationNotice = 'Não foi possível obter sinal de GPS.');
    }
  }

  void _listenPositionStream(
      AffineGeoTransform transform,
      PdfPixelMapper mapper,
      ) {
    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: _locationSettings(continuous: true),
    ).listen(
          (position) => _updateUserPosition(position, transform, mapper),
      onError: (e) {
        if (!mounted) return;
        setState(() => _locationNotice = 'Sinal de GPS perdido. Reconectando…');
        // reconecta em vez de deixar o stream morto de vez
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) _listenPositionStream(transform, mapper);
        });
      },
      onDone: () {
        // alguns fabricantes de Android fecham o stream sozinhos
        // depois de um tempo em segundo plano; reabre automaticamente
        if (mounted) {
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) _listenPositionStream(transform, mapper);
          });
        }
      },
    );
  }

  void _updateUserPosition(
      Position position,
      AffineGeoTransform transform,
      PdfPixelMapper mapper,
      ) {
    final userPdfPos = transform.geoToPdf(position.latitude, position.longitude);
    final userPixel = mapper.toPixel(userPdfPos.x, userPdfPos.y);
    final userOffset = Offset(userPixel.x, userPixel.y);

    // chegou perto o suficiente do destino final?
    final distToTarget = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      widget.targetLat,
      widget.targetLon,
    );
    final arrived = distToTarget <= _arrivedThresholdMeters;

    bool offTrail = false;
    double? offTrailDist;
    Offset? nearestTrailPixel;

    if (_trailPixels.length >= 2) {
      final proj = _projectOntoTrail(userOffset);
      if (proj != null) {
        nearestTrailPixel = proj.point;

        // ponto correspondente em lat/lon, interpolando com o mesmo t
        // (válido porque geo->pdf->pixel são transformações lineares/afins,
        // então a fração ao longo do segmento é a mesma nos dois espaços)
        final a = _trailLatLon[proj.segmentIndex];
        final b = _trailLatLon[proj.segmentIndex + 1];
        final trailLat = a.lat + (b.lat - a.lat) * proj.t;
        final trailLon = a.lon + (b.lon - a.lon) * proj.t;

        final distMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          trailLat,
          trailLon,
        );
        offTrail = distMeters > _offTrailThresholdMeters;
        offTrailDist = distMeters;

        // só avança o progresso (e "apaga" o trecho andado) quando está
        // de fato sobre a trilha; se estiver longe, o progresso fica
        // parado até a pessoa voltar pro trajeto marcado
        if (!offTrail && proj.progress > _trailProgress) {
          _trailProgress = proj.progress;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _userPixel = userOffset;
      _locationNotice = null;
      _lastPositionAt = DateTime.now();
      _offTrail = offTrail;
      _offTrailDistanceMeters = offTrailDist;
      _nearestTrailPixel = nearestTrailPixel;
      _arrived = arrived;
    });
  }

  /// Projeta [p] na polyline da trilha, achando o ponto mais próximo
  /// *sobre a linha* (não só o vértice mais próximo).
  _TrailProjection? _projectOntoTrail(Offset p) {
    if (_trailPixels.length < 2) return null;

    double bestDistSq = double.infinity;
    _TrailProjection? best;

    for (int i = 0; i < _trailPixels.length - 1; i++) {
      final a = _trailPixels[i];
      final b = _trailPixels[i + 1];
      final ab = b - a;
      final abLenSq = ab.dx * ab.dx + ab.dy * ab.dy;

      double t = 0;
      if (abLenSq > 0) {
        final ap = p - a;
        t = ((ap.dx * ab.dx + ap.dy * ab.dy) / abLenSq).clamp(0.0, 1.0);
      }

      final proj = a + ab * t;
      final distSq = (proj - p).distanceSquared;
      if (distSq < bestDistSq) {
        bestDistSq = distSq;
        best = _TrailProjection(i + t, proj, i, t);
      }
    }
    return best;
  }

  /// Ponto (pixel) correspondente a um valor de progresso contínuo.
  Offset _pointAtProgress(double progress) {
    final idx = progress.floor().clamp(0, _trailPixels.length - 2);
    final t = (progress - idx).clamp(0.0, 1.0);
    final a = _trailPixels[idx];
    final b = _trailPixels[idx + 1];
    return a + (b - a) * t;
  }

  /// Trecho restante da trilha: do progresso atual até o destino.
  /// O que já foi andado (antes de _trailProgress) não entra aqui.
  List<Offset> _remainingTrailPoints() {
    if (_trailPixels.length < 2 || _targetTrailProgress == null) return const [];

    final lo = math.min(_trailProgress, _targetTrailProgress!);
    final hi = math.max(_trailProgress, _targetTrailProgress!);
    if (hi - lo < 0.01) return const [];

    final points = <Offset>[_pointAtProgress(lo)];
    final firstVertex = lo.ceil();
    final lastVertex = hi.floor();
    for (int i = firstVertex; i <= lastVertex; i++) {
      if (i >= 0 && i < _trailPixels.length) points.add(_trailPixels[i]);
    }
    points.add(_pointAtProgress(hi));
    return points;
  }

  void _fitToScreen(BoxConstraints constraints, double imgWidth, double imgHeight) {
    if (_initialFitDone) return;
    _initialFitDone = true;

    final coverScale = math.max(
      constraints.maxWidth / imgWidth,
      constraints.maxHeight / imgHeight,
    );

    // zoom inicial: mais próximo do destino do que o "cover" da imagem
    // toda, já que agora o mapa cobre a região inteira, não só a trilha.
    final focusScale = _markerPixel != null
        ? math.min(coverScale * _initialZoomFactor, coverScale * 12)
        : coverScale;

    double dx = 0, dy = 0;
    if (_markerPixel != null) {
      dx = constraints.maxWidth / 2 - _markerPixel!.dx * focusScale;
      dy = constraints.maxHeight / 2 - _markerPixel!.dy * focusScale;

      final minDx = math.min(0.0, constraints.maxWidth - imgWidth * focusScale);
      final minDy = math.min(0.0, constraints.maxHeight - imgHeight * focusScale);
      dx = dx.clamp(minDx, 0.0);
      dy = dy.clamp(minDy, 0.0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transformController.value = Matrix4.identity()
        ..translate(dx, dy)
        ..scale(focusScale);
    });
  }

  String? get _bottomBannerText {
    if (_locationNotice != null) return _locationNotice;
    if (_arrived) return 'Você chegou! 🎉';
    if (_offTrail && _offTrailDistanceMeters != null) {
      return 'Você saiu da trilha marcada (${_offTrailDistanceMeters!.toStringAsFixed(0)}m). Siga a linha até o traçado.';
    }
    if (_lastPositionAt != null) {
      final secs = DateTime.now().difference(_lastPositionAt!).inSeconds;
      if (secs > 15) {
        return 'Última atualização há ${secs}s';
      }
    }
    return null;
  }

  Color get _bottomBannerColor {
    if (_locationNotice != null) return Colors.black87;
    if (_arrived) return Colors.green.shade900;
    if (_offTrail) return Colors.orange.shade900;
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final banner = _bottomBannerText;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Mapa da trilha'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
      bottomNavigationBar: banner == null
          ? null
          : Container(
        color: _bottomBannerColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          banner,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_rendered == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    final imgWidth = (_rendered!.width ?? 1).toDouble();
    final imgHeight = (_rendered!.height ?? 1).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        _fitToScreen(constraints, imgWidth, imgHeight);

        final coverScale = math.max(
          constraints.maxWidth / imgWidth,
          constraints.maxHeight / imgHeight,
        );

        final remaining = _remainingTrailPoints();

        return InteractiveViewer(
          transformationController: _transformController,
          constrained: false,
          minScale: coverScale * 0.9,
          maxScale: coverScale * 16, // era * 8flutter
          boundaryMargin: const EdgeInsets.all(200),
          child: SizedBox(
            width: imgWidth,
            height: imgHeight,
            child: Stack(
              children: [
                Image.memory(
                  _rendered!.bytes,
                  width: imgWidth,
                  height: imgHeight,
                  fit: BoxFit.fill,
                ),
                // trecho restante da trilha (o já andado some)
                if (remaining.length >= 2)
                  CustomPaint(
                    size: Size(imgWidth, imgHeight),
                    painter: _TrailPainter(points: remaining, color: Colors.blueAccent),
                  )
                // fallback: sem dados de trilha, linha reta como antes
                else if (_trailPixels.isEmpty && _markerPixel != null && _userPixel != null)
                  CustomPaint(
                    size: Size(imgWidth, imgHeight),
                    painter: _TrailPainter(
                      points: [_userPixel!, _markerPixel!],
                      color: Colors.blueAccent,
                    ),
                  ),
                // "volte pra cá": conecta o usuário ao ponto mais próximo
                // da trilha quando ele sai do trajeto marcado
                if (_offTrail && _userPixel != null && _nearestTrailPixel != null)
                  CustomPaint(
                    size: Size(imgWidth, imgHeight),
                    painter: _TrailPainter(
                      points: [_userPixel!, _nearestTrailPixel!],
                      color: Colors.orangeAccent,
                    ),
                  ),
                if (_userPixel != null)
                  Positioned(
                    left: _userPixel!.dx - 10,
                    top: _userPixel!.dy - 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _offTrail ? Colors.orangeAccent : Colors.blueAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                if (_markerPixel != null)
                  Positioned(
                    left: _markerPixel!.dx - 16,
                    top: _markerPixel!.dy - 32,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                      size: 40,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black87)],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _transformController.dispose();
    super.dispose();
  }
}

/// Desenha uma linha tracejada seguindo uma sequência de pontos.
class _TrailPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  _TrailPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const dashWidth = 10.0;
    const dashSpace = 6.0;

    for (int i = 0; i < points.length - 1; i++) {
      final from = points[i];
      final to = points[i + 1];
      final distance = (to - from).distance;
      if (distance == 0) continue;
      final direction = (to - from) / distance;

      double covered = 0;
      while (covered < distance) {
        final start = from + direction * covered;
        final end = from + direction * math.min(covered + dashWidth, distance);
        canvas.drawLine(start, end, paint);
        covered += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter oldDelegate) =>
      !_listEquals(oldDelegate.points, points) || oldDelegate.color != color;

  bool _listEquals(List<Offset> a, List<Offset> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}