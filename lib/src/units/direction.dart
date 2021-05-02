import 'package:metar_dart/src/units/angle.dart';
import 'package:metar_dart/src/utils/errors.dart';

class Direction {
  /*
   * The value of this direction from Metar report
  */
  final Map<String, List<double>> _compassDirs = {
    'N': [348.75, 11.25],
    'NNE': [11.25, 33.75],
    'NE': [33.75, 56.25],
    'ENE': [56.25, 78.75],
    'E': [78.75, 101.25],
    'ESE': [101.25, 123.75],
    'SE': [123.75, 146.25],
    'SSE': [146.25, 168.75],
    'S': [168.75, 191.25],
    'SSW': [191.25, 213.75],
    'SW': [213.75, 236.25],
    'WSW': [236.25, 258.75],
    'W': [258.75, 281.25],
    'WNW': [281.25, 303.75],
    'NW': [303.75, 326.25],
    'NNW': [326.25, 348.75],
  };
  Angle _direction;
  String _directionStr;
  bool _variable = false;

  Direction.fromDegrees({String value = '000'}) {
    final _value = double.parse(value);
    if (_value > 360 || _value < 0) {
      throw ValueError('Value $value must be in range 0-360.');
    }
    _direction = Angle.fromDegrees(value: _value);

    if (_value >= 348.75 || _value < 11.25) {
      _directionStr = 'N';
    }

    for (var key in _compassDirs.keys.toList().sublist(1)) {
      if (_value >= _compassDirs[key].first &&
          _value < _compassDirs[key].last) {
        _directionStr = key;
      }
    }
  }
  Direction.fromUndefined({String value = '///'}) {
    if (value == 'VRB') {
      _variable = true;
      _direction = Angle.fromDegrees(value: 0.0);
    }
  }
  Direction.fromCardinalDirection({String value = 'N'}) {
    double angle;

    if (_compassDirs.keys.toList().contains(value)) {
      _directionStr = value;

      angle = (value == 'N')
          ? 360.0
          : (_compassDirs[value][0] + _compassDirs[value][1]) / 2;
      _direction = Angle.fromDegrees(value: angle);
    } else {
      throw ValueError(
          'Value $value is not a cardinal direction or is not supported.');
    }
  }

  double get directionInDegrees => _returnValue('degrees');
  double get directionInRadians => _returnValue('radians');
  double get directionInGradians => _returnValue('gradians');
  String get cardinalDirection => _directionStr;
  bool get variable => _variable;

  double _returnValue(String format) {
    if (_directionStr == 'VRB' ||
        _directionStr == '///' ||
        _directionStr == 'MMM') {
      return null;
    }
    if (format == 'degrees') {
      return _direction.inDegrees;
    } else if (format == 'radians') {
      return _direction.inRadians;
    } else {
      return _direction.inGradians;
    }
  }
}
