import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the type of report. First sample.', () {
    final code =
        'SPECI UUDD 060030Z 18004MPS CAVOK M01/M04 Q1002 R14R/CLRD60 NOSIG';
    final metar = Metar(code);

    test('Test the type: SPECI.', () {
      final value = metar.type;
      print(metar.toString());
      expect(value, 'Special Meteorological Aerodrome Report');
    });
  });

  group('Test the type of report. First sample.', () {
    final code =
        'METAR UUDD 060000Z 18004MPS CAVOK M01/M04 Q1002 R14R/CLRD60 NOSIG';
    final metar = Metar(code);

    test('Test the type: SPECI.', () {
      final value = metar.type;
      print(metar.toString());
      expect(value, 'Meteorological Aerodrome Report');
    });
  });
}
