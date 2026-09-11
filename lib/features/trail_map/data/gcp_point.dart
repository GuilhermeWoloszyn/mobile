class GcpPoint {
  final double lat;
  final double lon;
  final double pdfX;
  final double pdfY;

  const GcpPoint({
    required this.lat,
    required this.lon,
    required this.pdfX,
    required this.pdfY,
  });

  factory GcpPoint.fromJson(Map<String, dynamic> j) => GcpPoint(
    lat: (j['lat'] as num).toDouble(),
    lon: (j['lon'] as num).toDouble(),
    pdfX: (j['pdfX'] as num).toDouble(),
    pdfY: (j['pdfY'] as num).toDouble(),
  );
}