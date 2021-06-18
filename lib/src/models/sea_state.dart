import 'package:metar_dart/src/units/units.dart';
import 'package:metar_dart/src/database/translations.dart';
import 'package:metar_dart/src/utils/capitalize_string.dart';

class SeaState {
  final RegExpMatch _match;
  final _translations = SKY_TRANSLATIONS().SEA_STATE;
  Temperature _temperature;
  String _sign;
  String _temp;
  String _state;

  SeaState(this._match) {
    _sign = _match.namedGroup('sign');
    _temp = _match.namedGroup('temp');
    _state = _match.namedGroup('state');

    _temperature = _setTemperature(_temp);

    _state = capitalize(_translations[_state]);
  }

  Temperature _setTemperature(String code) {
    if (_sign == 'M') {
      return Temperature.fromCelsius(value: double.parse('-' + code));
    }
    return Temperature.fromCelsius(value: double.parse(code));
  }

  @override
  String toString() {
    return 'Temperature: ${_temperature.inCelsius}°. '
        'State: $_state\n';
  }

  // Getters
  Temperature get temperature => _temperature;
  String get state => _state;
}
