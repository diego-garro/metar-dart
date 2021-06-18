import 'package:test/test.dart';

import 'package:metar_dart/metar_dart.dart';

void main() {
  group('Test the sea state of METAR. Positive temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA W20/S5';
    final metar = Metar(code);
    final seaState = metar.seaState;

    test('Test the temperature', () {
      final value = seaState.temperature.inCelsius;
      expect(value, 20.0);
    });

    test('Test the state', () {
      final value = seaState.state;
      expect(value, 'Rough');
    });
  });

  group('Test the sea state of METAR. Negative temperature', () {
    final code =
        'METAR LXGB 201950Z AUTO 09012KT 9999 BKN080/// 14/07 Q1016 RERA WM01/S8';
    final metar = Metar(code);
    final seaState = metar.seaState;

    test('Test the temperature', () {
      final value = seaState.temperature.inCelsius;
      expect(value, -1.0);
    });

    test('Test the state', () {
      final value = seaState.state;
      expect(value, 'Very high');
    });
  });
}
