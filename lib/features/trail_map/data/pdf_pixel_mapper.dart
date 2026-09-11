class PdfPixelMapper {
  final double pageHeightPt;
  final double scale;

  const PdfPixelMapper({required this.pageHeightPt, required this.scale});

  ({double x, double y}) toPixel(double pdfX, double pdfY) {
    final px = pdfX * scale;
    final py = (pageHeightPt - pdfY) * scale; // inverte eixo Y
    return (x: px, y: py);
  }
}