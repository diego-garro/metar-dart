import 'package:metar_dart/src/units/units.dart';

class Wind {
  final RegExpMatch _match;
  Direction _direction;
  Speed _speed;
  Speed _gust;

  Wind(this._match) {
    _set_direction(_match.namedGroup('dir'));

    _set_speed(_match.namedGroup('speed'), _match.namedGroup('units'));

    _set_gust(_match.namedGroup('gust'), _match.namedGroup('units'));
  }

  void _set_direction(String code) {
    if (code != null && RegExp(r'^\d{3}$').hasMatch(code)) {
      _direction = Direction.fromDegrees(value: code);
    } else {
      _direction = Direction.fromUndefined(value: code);
    }
  }

  void _set_speed(String code, String units) {
    if (code != null && RegExp(r'^\d{2}$').hasMatch(code)) {
      if (units == 'KT' || units == 'KTS') {
        _speed = Speed.fromKnot(value: double.parse(code));
      } else {
        _speed = Speed.fromMeterPerSecond(value: double.parse(code));
      }
    }
  }

  void _set_gust(String code, String units) {
    if (code != null && RegExp(r'^\d{2}').hasMatch(code)) {
      if (units == 'KT' || units == 'KTS') {
        _gust = Speed.fromKnot(value: double.parse(code));
      } else {
        _gust = Speed.fromMeterPerSecond(value: double.parse(code));
      }
    }
  }

  @override
  String toString() {
    return '--- Wind ---\n'
        ' * Direction:\n'
        '   - Degrees: ${_direction.variable ? 'Varibale' : '${_direction.directionInDegrees}°'}\n'
        '   - Cardinal point: ${_direction.variable ? 'Variable' : _direction.cardinalPoint}\n'
        ' * Speed: ${_speed != null ? _speed.inKnot : 0.0} knots\n'
        ' * Gust: ${_gust != null ? _gust.inKnot : 0.0} knots\n';
  }

  // Getters
  Direction get direction => _direction;
  Speed get speed => _speed;
  Speed get gust => _gust;
}
