import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  final code =
      'METAR SEQM 162000Z 34012G22KT 310V020 9999 VCSH SCT030 BKN200 21/12 Q1022 NOSIG RMK A3018';
  final metar = Metar(code);

  group('Test the wind direction of METAR', () {
    test('Test the direction in degrees', () {
      final value = metar.wind.direction.directionInDegrees;
      expect(value, 340.0);
    });

    test('Test the cardinal point of wind direction', () {
      final value = metar.wind.direction.cardinalDirection;
      expect(value, 'NNW');
    });
  });

  group('Test the wind speed of METAR', () {
    test('Test the wind speedn in knots', () {
      final value = metar.wind.speed.inKnot;
      expect(value, 12.0);
    });

    test('Test the wind speed in km/h', () {
      final value = metar.wind.speed.inKilometerPerHour;
      expect(value, 22.224);
    });

    test('Test the wind speed in m/s', () {
      final value = metar.wind.speed.inMeterPerSecond;
      expect(value, 6.173333);
    });
  });

  group('Test the wind gust of METAR', () {
    test('Test the wind gust in knots', () {
      final value = metar.wind.gust.inKnot;
      expect(value, 22.0);
    });

    test('Test the wind gust in km/h', () {
      final value = metar.wind.gust.inKilometerPerHour;
      expect(value, 40.744);
    });

    test('Test the wind gust in m/s', () {
      final value = metar.wind.gust.inMeterPerSecond;
      expect(value, 11.317778);
    });
  });

  group('Test the wind direction variation of METAR', () {
    test('Test the from variation in degrees', () {
      final value = metar.windVariation?.from?.directionInDegrees;
      expect(value, 310.0);
    });

    test('Test the from variation cardinal point', () {
      final value = metar.windVariation?.from?.cardinalDirection;
      expect(value, 'NW');
    });

    test('Test the to variation in degrees', () {
      final value = metar.windVariation?.to?.directionInDegrees;
      expect(value, 20.0);
    });

    test('Test the to variation cardinal point', () {
      final value = metar.windVariation?.to?.cardinalDirection;
      expect(value, 'NNE');
    });
  });
}
