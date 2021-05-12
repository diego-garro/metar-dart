import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the weather of METAR. Sample No. 1', () {
    final code =
        'METAR UUDD 190430Z 35004MPS 8000 -SN FEW012 M01/M03 Q1009 R32L/590240 NOSIG';
    final metar = Metar(code);
    final weather_1 = metar.weather[0];

    test('Test the intensity', () {
      final value = weather_1.intensity;
      expect(value, 'light');
    });

    test('Test the description', () {
      final value = weather_1.description;
      expect(value, '');
    });

    test('Test the precipitation', () {
      final value = weather_1.precipitation;
      expect(value, 'snow');
    });

    test('Test the obscuration', () {
      final value = weather_1.obscuration;
      expect(value, '');
    });

    test('Test the other', () {
      final value = weather_1.other;
      expect(value, '');
    });
  });

  group('Test the weather of METAR. Sample No. 2', () {
    final code =
        'METAR MRLM 191300Z 22005KT 6000 DZ VCSH FEW010TCU OVC070 24/23 A2991 RERA';
    final metar = Metar(code);
    final weather_1 = metar.weather[0];
    final weather_2 = metar.weather[1];

    test('Test the intensity', () {
      final value_1 = weather_1.intensity;
      final value_2 = weather_2.intensity;
      expect(value_1, '');
      expect(value_2, 'nearby');
    });

    test('Test the description', () {
      final value_1 = weather_1.description;
      final value_2 = weather_2.description;
      expect(value_1, '');
      expect(value_2, 'showers');
    });

    test('Test the precipitation', () {
      final value_1 = weather_1.precipitation;
      final value_2 = weather_2.precipitation;
      expect(value_1, 'drizzle');
      expect(value_2, '');
    });

    test('Test the obscuration', () {
      final value_1 = weather_1.obscuration;
      final value_2 = weather_2.obscuration;
      expect(value_1, '');
      expect(value_2, '');
    });

    test('Test the other', () {
      final value_1 = weather_1.other;
      final value_2 = weather_2.other;
      expect(value_1, '');
      expect(value_2, '');
    });
  });

  group('Test the weather of METAR. Sample No. 3', () {
    final code =
        'METAR BIBD 191100Z 03002KT 8000 RA BR VCTS SCT008CB OVC020 04/03 Q1013';
    final metar = Metar(code);
    final weather_1 = metar.weather[0];
    final weather_2 = metar.weather[1];
    final weather_3 = metar.weather[2];

    test('Test the intensity', () {
      final value_1 = weather_1.intensity;
      final value_2 = weather_2.intensity;
      final value_3 = weather_3.intensity;
      expect(value_1, '');
      expect(value_2, '');
      expect(value_3, 'nearby');
    });

    test('Test the description', () {
      final value_1 = weather_1.description;
      final value_2 = weather_2.description;
      final value_3 = weather_3.description;
      expect(value_1, '');
      expect(value_2, '');
      expect(value_3, 'thunderstorm');
    });

    test('Test the precipitation', () {
      final value_1 = weather_1.precipitation;
      final value_2 = weather_2.precipitation;
      final value_3 = weather_3.precipitation;
      expect(value_1, 'rain');
      expect(value_2, '');
      expect(value_3, '');
    });

    test('Test the obscuration', () {
      final value_1 = weather_1.obscuration;
      final value_2 = weather_2.obscuration;
      final value_3 = weather_3.obscuration;
      expect(value_1, '');
      expect(value_2, 'mist');
      expect(value_3, '');
    });

    test('Test the other', () {
      final value_1 = weather_1.other;
      final value_2 = weather_2.other;
      final value_3 = weather_3.other;
      expect(value_1, '');
      expect(value_2, '');
      expect(value_3, '');
    });
  });
}
