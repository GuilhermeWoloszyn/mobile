import 'gcp_point.dart';

class AffineGeoTransform {
  double a = 0, b = 0, c = 0, d = 0, e = 0, f = 0;
  bool valid = false;

  void fit(List<GcpPoint> gcps) {
    if (gcps.length < 2) {
      valid = false;
      return;
    }
    if (gcps.length == 2) {
      _fitTwoPoints(gcps[0], gcps[1]);
    } else {
      _fitLeastSquares(gcps);
    }
  }

  void _fitTwoPoints(GcpPoint p1, GcpPoint p2) {
    final dLon = p2.lon - p1.lon;
    final dLat = p2.lat - p1.lat;
    if (dLon == 0 || dLat == 0) {
      valid = false;
      return;
    }
    a = (p2.pdfX - p1.pdfX) / dLon;
    c = p1.pdfX - a * p1.lon;
    b = 0;

    e = (p2.pdfY - p1.pdfY) / dLat;
    f = p1.pdfY - e * p1.lat;
    d = 0;
    valid = true;
  }

  void _fitLeastSquares(List<GcpPoint> gcps) {
    final ataX = List.generate(3, (_) => List<double>.filled(3, 0));
    final atbX = List<double>.filled(3, 0);
    final ataY = List.generate(3, (_) => List<double>.filled(3, 0));
    final atbY = List<double>.filled(3, 0);

    for (final p in gcps) {
      final row = [p.lon, p.lat, 1.0];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          ataX[i][j] += row[i] * row[j];
          ataY[i][j] += row[i] * row[j];
        }
        atbX[i] += row[i] * p.pdfX;
        atbY[i] += row[i] * p.pdfY;
      }
    }

    final solX = _solve3x3(ataX, atbX);
    final solY = _solve3x3(ataY, atbY);

    if (solX == null || solY == null) {
      valid = false;
      return;
    }

    a = solX[0];
    b = solX[1];
    c = solX[2];
    d = solY[0];
    e = solY[1];
    f = solY[2];
    valid = true;
  }

  List<double>? _solve3x3(List<List<double>> matrix, List<double> vector) {
    final m = List.generate(3, (i) => List<double>.from(matrix[i]));
    final v = List<double>.from(vector);

    for (int col = 0; col < 3; col++) {
      int pivotRow = col;
      double maxVal = m[col][col].abs();
      for (int row = col + 1; row < 3; row++) {
        if (m[row][col].abs() > maxVal) {
          maxVal = m[row][col].abs();
          pivotRow = row;
        }
      }

      if (maxVal < 1e-10) {
        return null;
      }

      if (pivotRow != col) {
        final tmpRow = m[col];
        m[col] = m[pivotRow];
        m[pivotRow] = tmpRow;
        final tmpVal = v[col];
        v[col] = v[pivotRow];
        v[pivotRow] = tmpVal;
      }

      for (int row = col + 1; row < 3; row++) {
        final factor = m[row][col] / m[col][col];
        for (int k = col; k < 3; k++) {
          m[row][k] -= factor * m[col][k];
        }
        v[row] -= factor * v[col];
      }
    }

    final result = List<double>.filled(3, 0);
    for (int row = 2; row >= 0; row--) {
      double sum = v[row];
      for (int col = row + 1; col < 3; col++) {
        sum -= m[row][col] * result[col];
      }
      result[row] = sum / m[row][row];
    }
    return result;
  }

  ({double x, double y}) geoToPdf(double lat, double lon) {
    final x = a * lon + b * lat + c;
    final y = d * lon + e * lat + f;
    return (x: x, y: y);
  }
}