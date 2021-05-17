import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the sky items of METAR', () {
    final code = 'METAR BIAR 190800Z 20015KT 9999 FEW049 BKN056 10/03 Q1016';
    final metar = Metar(code);
    final layer_1 = metar.sky[0];
    final layer_2 = metar.sky[1];

    test('Test the cover of sky layers', () {
      final value_1 = layer_1.cover;
      final value_2 = layer_2.cover;
      expect(value_1, 'a few');
      expect(value_2, 'broken');
    });

    test('Test the length in feet of sky layers', () {
      final value_1 = layer_1.height.inFeet;
      final value_2 = layer_2.height.inFeet;
      expect(value_1, 4900.0);
      expect(value_2, 5600.0);
    });

    test('Test the length in kilometers of sky layers', () {
      final value_1 = layer_1.height.inKilometers;
      final value_2 = layer_2.height.inKilometers;
      expect(value_1, 1.49);
      expect(value_2, 1.71);
    });

    test('Test the length in miles of sky layers', () {
      final value_1 = layer_1.height.inMiles;
      final value_2 = layer_2.height.inMiles;
      expect(value_1, 0.93);
      expect(value_2, 1.06);
    });

    test('Test the cloud type of sky layers', () {
      final value_1 = layer_1.cloud;
      final value_2 = layer_2.cloud;
      expect(value_1, '');
      expect(value_2, '');
    });
  });

  group('Test the sky items of METAR', () {
    final code =
        'METAR KMIA 191458Z 33006KT 5SM R09/1800V4500FT -TSRA BR FEW013 BKN021CB OVC040 23/21 A3003 RMK AO2 OCNL LTGICCG OHD TS OHD MOV SE P0007 T02280211';
    final metar = Metar(code);
    final layer_1 = metar.sky[0];
    final layer_2 = metar.sky[1];
    final layer_3 = metar.sky[2];

    test('Test the cover of sky layers', () {
      final value_1 = layer_1.cover;
      final value_2 = layer_2.cover;
      final value_3 = layer_3.cover;
      expect(value_1, 'a few');
      expect(value_2, 'broken');
      expect(value_3, 'overcast');
    });

    test('Test the length in feet of sky layers', () {
      final value_1 = layer_1.height.inFeet;
      final value_2 = layer_2.height.inFeet;
      final value_3 = layer_3.height.inFeet;
      expect(value_1, 1300.0);
      expect(value_2, 2100.0);
      expect(value_3, 4000.0);
    });

    test('Test the length in kilometers of sky layers', () {
      final value_1 = layer_1.height.inKilometers;
      final value_2 = layer_2.height.inKilometers;
      final value_3 = layer_3.height.inKilometers;
      expect(value_1, 0.40);
      expect(value_2, 0.64);
      expect(value_3, 1.22);
    });

    test('Test the length in miles of sky layers', () {
      final value_1 = layer_1.height.inMiles;
      final value_2 = layer_2.height.inMiles;
      final value_3 = layer_3.height.inMiles;
      expect(value_1, 0.25);
      expect(value_2, 0.40);
      expect(value_3, 0.76);
    });

    test('Test the cloud type of sky layers', () {
      final value_1 = layer_1.cloud;
      final value_2 = layer_2.cloud;
      final value_3 = layer_3.cloud;
      expect(value_1, '');
      expect(value_2, 'cumulonimbus');
      expect(value_3, '');
    });
  });
}
