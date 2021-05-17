import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the temperatures of METAR', () {
    final code =
        'METAR LHBP 191530Z 17007KT 9999 VCSH FEW018CB SCT029 04/M03 Q1015 NOSIG';
    final metar = Metar(code);
    final temps = metar.temperatures;

    test('Test the absolute temperature in Celsius', () {
      final value = temps.temperature.inCelsius;
      expect(value, 4.0);
    });

    test('Test the absolute temperature in Fahrenheit', () {
      final value = temps.temperature.inFahrenheit;
      expect(value, 39.2);
    });

    test('Test the absolute temperature in Kelvin', () {
      final value = temps.temperature.inKelvin;
      expect(value, 277.15);
    });

    test('Test the dewpoint temperature in Celsius', () {
      final value = temps.dewpoint.inCelsius;
      expect(value, -3.0);
    });

    test('Test the dewpoint temperature in Fahrenheit', () {
      final value = temps.dewpoint.inFahrenheit;
      expect(value, 26.6);
    });

    test('Test the dewpoint temperature in Kelvin', () {
      final value = temps.dewpoint.inKelvin;
      expect(value, 270.15);
    });
  });

  group('Test the temperatures of METAR', () {
    final code =
        'METAR MSSS 182050Z 17011KT 130V220 9999 FEW060 31/19 Q1012 A2990';
    final metar = Metar(code);
    final temps = metar.temperatures;

    test('Test the absolute temperature in Celsius', () {
      final value = temps.temperature.inCelsius;
      expect(value, 31.0);
    });

    test('Test the absolute temperature in Fahrenheit', () {
      final value = temps.temperature.inFahrenheit;
      expect(value, 87.8);
    });

    test('Test the absolute temperature in Kelvin', () {
      final value = temps.temperature.inKelvin;
      expect(value, 304.15);
    });

    test('Test the dewpoint temperature in Celsius', () {
      final value = temps.dewpoint.inCelsius;
      expect(value, 19.0);
    });

    test('Test the dewpoint temperature in Fahrenheit', () {
      final value = temps.dewpoint.inFahrenheit;
      expect(value, 66.2);
    });

    test('Test the dewpoint temperature in Kelvin', () {
      final value = temps.dewpoint.inKelvin;
      expect(value, 292.15);
    });
  });

  group('Test the temperatures of METAR', () {
    final code =
        'METAR MSSS 182050Z 17011KT 130V220 9999 FEW060 ///// Q1012 A2990';
    final metar = Metar(code);
    final temps = metar.temperatures;

    test('Test the absolute temperature in Celsius', () {
      final value = temps.temperature?.inCelsius;
      expect(value, null);
    });

    test('Test the dewpoint temperature in Celsius', () {
      final value = temps.dewpoint?.inCelsius;
      expect(value, null);
    });
  });
}
