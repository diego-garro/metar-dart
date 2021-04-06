import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      'SPECI KJFK 122051Z 32004KT 10SM OVC065 M02/M15 A3031 RMK AO2 SLP264 T10171150 56004';
  final metar = Metar(code, utcMonth: 3, utcYear: 2021);

  group('Test the date of METAR', () {
    test('Test the year', () {
      final value = metar.time.year;
      expect(value, 2021);
    });

    test('Test the month', () {
      final value = metar.time.month;
      expect(value, 3);
    });

    test('Test the day', () {
      final value = metar.time.day;
      expect(value, 12);
    });

    test('Test the hour', () {
      final value = metar.time.hour;
      expect(value, 20);
    });

    test('Test the minute', () {
      final value = metar.time.minute;
      expect(value, 51);
    });
  });
}
