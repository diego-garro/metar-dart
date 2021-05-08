import 'package:metar_dart/src/units/units.dart';

class Runway {
  final RegExpMatch _match;
  String _name;
  String _rvrLow;
  String _lRange;
  String _rvrHigh;
  String _hRange;
  String _units;
  String _trend;
  Length _highRange;
  Length _lowRange;

  Runway(this._match) {
    _name = _match.namedGroup('name');
    _rvrLow = _match.namedGroup('rvrlow');
    _lRange = _match.namedGroup('low');
    _rvrHigh = _match.namedGroup('rvrhigh');
    _hRange = _match.namedGroup('high');
    _units = _match.namedGroup('units');
    _trend = _match.namedGroup('trend');

    _setUnits();
    _setTrend();
    _setName();
    _lowRange = _setRange(_lRange);
    _rvrLow = _setRVR(_rvrLow);
    _highRange = _setRange(_hRange);
    _rvrHigh = _setRVR(_rvrHigh);
  }

  void _setUnits() {
    if (_units == 'FT') {
      _units = 'feet';
    } else {
      _units = 'meters';
    }
  }

  void _setTrend() {
    if (_trend == 'N') {
      _trend = 'no change';
    } else if (_trend == 'U') {
      _trend = 'increasing';
    } else if (_trend == 'D') {
      _trend = 'decreasing';
    } else {
      _trend = '';
    }
  }

  void _setName() {
    _name = _name
        .substring(1)
        .replaceFirst('L', ' left')
        .replaceFirst('R', ' right')
        .replaceFirst('C', ' center');
  }

  Length _setRange(String range) {
    if (range == null) {
      return Length.fromMeters(value: 0.0);
    }

    final value = double.parse(range);

    if (_units == 'feet') {
      return Length.fromFeet(value: value);
    } else {
      return Length.fromMeters(value: value);
    }
  }

  String _setRVR(String rvr) {
    if (rvr == 'P') {
      return 'greater than';
    } else if (rvr == 'M') {
      return 'less than';
    } else {
      return '';
    }
  }

  @override
  String toString() {
    final string = '   - Name: $_name\n'
        '     > Low range: $_rvrLow ${_lowRange.inMeters} meters\n'
        '     > High range: $_rvrHigh ${_highRange.inMeters} meters\n'
        '     > Trend: $_trend';
    ;

    return string.replaceAll(RegExp(r'\s+'), ' ');
  }

  String get name => _name;
  String get rvrLow => _rvrLow;
  String get rvrHigh => _rvrHigh;
  Length get highRange => _highRange;
  Length get lowRange => _lowRange;
  String get trend => _trend;
}
