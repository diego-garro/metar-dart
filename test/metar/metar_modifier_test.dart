import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the modifier of METAR', () {
    final code =
        'METAR KJST 060154Z AUTO 05007KT 10SM OVC085 13/01 A3004 RMK AO2 SLP174 T01280006';
    final metar = Metar(code);

    test('Test the modifier', () {
      final value = metar.modifier;
      expect(value, 'Automatic report');
    });
  });

  group('Test the modifier of missing METAR', () {
    final code = 'METAR KJST 060100Z NIL';
    final metar = Metar(code);

    test('Test the modifier', () {
      final value = metar.modifier;
      expect(value, 'Missing report');
    });
  });
}
