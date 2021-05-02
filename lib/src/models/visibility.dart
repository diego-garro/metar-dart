import 'package:metar_dart/src/units/units.dart';

class Visibility {
  final RegExpMatch _match;
  Length _value;
  Direction _direction;
  String _opt;
  String _vis;
  String _dir;
  String _units;
  String _visExtreme;
  String _cavok;

  Visibility(this._match) {
    _opt = _match.namedGroup('opt');
    _vis = _match.namedGroup('vis');
    _dir = _match.namedGroup('dir');
    _units = _match.namedGroup('units');
    _visExtreme = _match.namedGroup('visextreme');
    _cavok = _match.namedGroup('cavok');

    _units ??= _units = 'M';

    if (_dir != null) {
      _direction = Direction.fromCardinalDirection(value: _dir);
    }

    _set_visibility();
  }

  void _set_visibility() {
    if (_visExtreme != null && _visExtreme.contains('/')) {
      var items = _visExtreme.split('/');

      if (_opt != null) {
        _visExtreme =
            '${double.parse(_opt) + int.parse(items[0]) / int.parse(items[1])}';
      } else {
        _visExtreme = '${int.parse(items[0]) / int.parse(items[1])}';
      }
    }

    if (_units == 'SM' && _vis != null) {
      _value = Length.fromMiles(value: double.parse(_vis));
    } else if (_units == 'SM') {
      _value = Length.fromMiles(value: double.parse(_visExtreme));
    } else if (_units == 'KM') {
      _value = Length.fromKilometers(value: double.parse(_visExtreme));
    } else {
      if (_vis == '9999' || _cavok == 'CAVOK') {
        _value = Length.fromMeters(value: double.parse('10000'));
      } else {
        _value = Length.fromMeters(value: double.parse(_vis));
      }
    }
  }

  @override
  String toString() {
    return '${_value.inMeters} meters${_direction != null ? " to $_direction" : ""}';
  }

  Length get value => _value;
  Direction get direction => _direction;
}
