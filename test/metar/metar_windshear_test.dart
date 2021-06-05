import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the windshear of METAR. First sample.', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07 NOSIG';
    final metar = Metar(code);

    test('First test.', () {
      final value = metar.windshear[0].runway;
      expect(value, '07');
    });
  });

  group('Test the windshear of METAR. Second sample.', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS R07L WS R25C NOSIG';
    final metar = Metar(code);

    test('First test.', () {
      final value = metar.windshear[0].runway;
      expect(value, '07 left');
    });

    test('Second test.', () {
      final value = metar.windshear[1].runway;
      expect(value, '25 center');
    });
  });

  group('Test the windshear of METAR. Third sample.', () {
    final code =
        'METAR MROC 202000Z 12013G23KT 9999 FEW040 SCT100 27/16 A2997 WS ALL RWY NOSIG';
    final metar = Metar(code);

    test('First test.', () {
      final value = metar.windshear[0].runway;
      expect(value, 'All');
    });
  });
}
