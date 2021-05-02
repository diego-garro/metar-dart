import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the prevailing visibility from meters', () {
    final code =
        'METAR SBBV 170400Z 08004KT 9999 SCT030 FEW035TCU BKN070 26/23 Q1012';
    final metar = Metar(code);

    test('Test the visibility in kilometers', () {
      final value = metar.visibility.value.inKilometers;
      expect(value, 10.0);
    });

    test('Test the visibility in meters', () {
      final value = metar.visibility.value.inMeters;
      expect(value, 10000.0);
    });

    test('Test the visibility in feet', () {
      final value = metar.visibility.value.inFeet;
      expect(value, 32808.4);
    });

    test('Test the visibility in miles', () {
      final value = metar.visibility.value.inMiles;
      expect(value, 6.21);
    });
  });

  group('Test the prevailing visibility from sea miles in fractional', () {
    final code =
        'METAR PALH 170933Z 00000KT 1 1/4SM BR FEW002 M14/M16 A2980 RMK AO2 T11441156';
    final metar = Metar(code);

    test('Test the visibility in kilometers', () {
      final value = metar.visibility.value.inKilometers;
      expect(value, 2.01);
    });

    test('Test the visibility in meters', () {
      final value = metar.visibility.value.inMeters;
      expect(value, 2011.68);
    });

    test('Test the visibility in feet', () {
      final value = metar.visibility.value.inFeet;
      expect(value, 6600.0);
    });

    test('Test the visibility in miles', () {
      final value = metar.visibility.value.inMiles;
      expect(value, 1.25);
    });
  });

  group('Test the prevailing visibility from sea miles in integer', () {
    final code =
        'METAR PALH 170936Z 00000KT 5SM BR CLR M14/M16 A2980 RMK AO2 T11441161';
    final metar = Metar(code);

    test('Test the visibility in kilometers', () {
      final value = metar.visibility.value.inKilometers;
      expect(value, 8.05);
    });

    test('Test the visibility in meters', () {
      final value = metar.visibility.value.inMeters;
      expect(value, 8046.72);
    });

    test('Test the visibility in feet', () {
      final value = metar.visibility.value.inFeet;
      expect(value, 26400.0);
    });

    test('Test the visibility in miles', () {
      final value = metar.visibility.value.inMiles;
      expect(value, 5.0);
    });
  });

  group('Test the minimum visibility of METAR', () {
    final code =
        'METAR UUDD 180100Z 00000MPS 4800 2100NW -SN BR SCT025 M02/M03 Q1007 R32L/290042 NOSIG';
    final metar = Metar(code);

    test('Test the minimum visibility in kilometers', () {
      final value = metar.minimumVisibility.value.inKilometers;
      expect(value, 2.10);
    });

    test('Test the minimum visibility in meters', () {
      final value = metar.minimumVisibility.value.inMeters;
      expect(value, 2100.0);
    });

    test('Test the minimum visibility in feet', () {
      final value = metar.minimumVisibility.value.inFeet;
      expect(value, 6889.76);
    });

    test('Test the minimum visibility in miles', () {
      final value = metar.minimumVisibility.value.inMiles;
      expect(value, 1.3);
    });

    test('Test the minimum visibility direction in degrees', () {
      final value = metar.minimumVisibility.direction.directionInDegrees;
      expect(value, 315.0);
    });

    test('Test the cardinal point minimum visibility direction', () {
      final value = metar.minimumVisibility.direction.cardinalDirection;
      expect(value, 'NW');
    });

    test('Test the minimum visibility direction in radians', () {
      final value = metar.minimumVisibility.direction.directionInRadians;
      expect(value, 5.497787);
    });
  });

  // group('Test the runway range', () {
  //   final code =
  //       'METAR SCFA 121300Z 21008KT 9999 3000W R07L/M0150V0600U TSRA FEW020 20/13 Q1014 NOSIG';
  //   final metar = Metar(code);

  //   test('Test the name of runway', () {
  //     final value = metar.runwayRanges[0].item1;
  //     expect(value, '07 left');
  //   });

  //   test('Test the units of runway', () {
  //     final value = metar.runwayRanges[0].item2;
  //     expect(value, 'meters');
  //   });

  //   test('Test the low rvr of runway', () {
  //     final value = metar.runwayRanges[0].item3;
  //     expect(value, 'less than');
  //   });

  //   test('Test the low range of runway', () {
  //     final value = metar.runwayRanges[0].item4.inMeters;
  //     expect(value, 150.0);
  //   });

  //   test('Test the high rvr of runway', () {
  //     final value = metar.runwayRanges[0].item5;
  //     expect(value, '');
  //   });

  //   test('Test the high range of runway', () {
  //     final value = metar.runwayRanges[0].item6.inMeters;
  //     expect(value, 600.0);
  //   });

  //   test('Test the trend of runway', () {
  //     final value = metar.runwayRanges[0].item7;
  //     expect(value, 'increasing');
  //   });
  // });
}
