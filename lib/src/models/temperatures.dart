import 'package:metar_dart/src/units/units.dart';

class Temperatures {
  final RegExpMatch _match;
  Temperature _temperature;
  Temperature _dewpoint;

  Temperatures(this._match) {
    final _tsign = _match.namedGroup('tsign');
    final _temp = _match.namedGroup('temp');
    final _dsign = _match.namedGroup('dsign');
    final _dwpt = _match.namedGroup('dewpt');

    _temperature = _setTemperature(_tsign, _temp);
    _dewpoint = _setTemperature(_dsign, _dwpt);
  }

  Temperature _setTemperature(String sign, String value) {
    final nullTemps = ['//', 'XX', 'MM'];
    if (nullTemps.contains(value)) {
      return null;
    }

    if (sign == 'M' || sign == '-') {
      return Temperature.fromCelsius(value: double.parse('-$value'));
    }

    return Temperature.fromCelsius(value: double.parse(value));
  }

  @override
  String toString() {
    return (_temperature != null
            ? 'Temperature: ${_temperature.inCelsius} °C'
            : '') +
        (_dewpoint != null ? '\nDewpoint: ${_dewpoint.inCelsius} °C' : '');
  }

  Temperature get temperature => _temperature;
  Temperature get dewpoint => _dewpoint;
}
