import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the recent weather of METAR. Sample No. 1', () {
    final code =
        'METAR MRLM 192300Z 05010KT 5000 +DZ FEW010 OVC080 24/23 A2987 RERA';
    final metar = Metar(code);

    test('Test the description', () {
      final value = metar.recentWeather.description;
      expect(value, '');
    });

    test('Test the precipitation', () {
      final value = metar.recentWeather.precipitation;
      expect(value, 'rain');
    });

    test('Test the obscuration', () {
      final value = metar.recentWeather.obscuration;
      expect(value, '');
    });

    test('Test the other', () {
      final value = metar.recentWeather.other;
      expect(value, '');
    });
  });

  group('Test the recent weather of METAR. Sample No. 1', () {
    final code =
        'METAR SKBO 200800Z 36004KT 5000 RA FEW017 SCT070 10/09 Q1025 RETSGR NOSIG RMK A3029';
    final metar = Metar(code);

    test('Test the description', () {
      final value = metar.recentWeather.description;
      expect(value, 'thunderstorm');
    });

    test('Test the precipitation', () {
      final value = metar.recentWeather.precipitation;
      expect(value, 'hail');
    });

    test('Test the obscuration', () {
      final value = metar.recentWeather.obscuration;
      expect(value, '');
    });

    test('Test the other', () {
      final value = metar.recentWeather.other;
      expect(value, '');
    });
  });
}
