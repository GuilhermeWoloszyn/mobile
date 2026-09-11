import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/trail_map/data/affine_geo_transform.dart';
import 'package:untitled1/features/trail_map/data/gcp_point.dart';

void main() {
  test('geoToPdf reproduz os pontos de controle originais (round-trip)', () {
    final gcps = [
      GcpPoint(
          lat: -27.039349089126283,
          lon: -49.553957951881955,
          pdfX: 10.036404238244238,
          pdfY: 585.2391863129369),
      GcpPoint(
          lat: -27.039349089126283,
          lon: -49.508334016234144,
          pdfX: 831.0142709266214,
          pdfY: 585.2391863129369),
      GcpPoint(
          lat: -27.071587028985004,
          lon: -49.553957951881955,
          pdfX: 10.036404238244238,
          pdfY: 5.135021342420813),
      GcpPoint(
          lat: -27.071587028985004,
          lon: -49.508334016234144,
          pdfX: 831.0142709266214,
          pdfY: 5.135021342420813),
    ];

    final transform = AffineGeoTransform()..fit(gcps);

    expect(transform.valid, isTrue,
        reason: 'A transformação deveria ser válida com 4 GCPs bem distribuídos');

    for (final gcp in gcps) {
      final result = transform.geoToPdf(gcp.lat, gcp.lon);
      expect(result.x, closeTo(gcp.pdfX, 0.5),
          reason: 'pdfX errado para lat=${gcp.lat}, lon=${gcp.lon}');
      expect(result.y, closeTo(gcp.pdfY, 0.5),
          reason: 'pdfY errado para lat=${gcp.lat}, lon=${gcp.lon}');
    }

    final midLat = -27.055468;
    final midLon = -49.531146;
    final mid = transform.geoToPdf(midLat, midLon);
    expect(mid.x, closeTo(420.5, 5));
    expect(mid.y, closeTo(295, 5));
  });
}