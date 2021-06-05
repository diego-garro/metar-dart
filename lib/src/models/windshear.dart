import 'package:metar_dart/src/utils/capitalize_string.dart';

class Windshear {
  final RegExpMatch _match;
  final _rwyNames = {
    'R': 'right',
    'L': 'left',
    'C': 'center',
  };
  String _all;
  String _number;
  String _name;
  String _runway;

  Windshear(this._match) {
    _all = _match.namedGroup('all');
    _number = _match.namedGroup('num');
    _name = _match.namedGroup('name');

    if (_name != null) {
      _name = _rwyNames[_name];
    }

    _setRunway();
  }

  void _setRunway() {
    if (_all != null) {
      _runway = capitalize(_all);
    } else {
      _runway = '$_number${_name != null ? " $_name" : ""}';
    }
  }

  @override
  String toString() {
    return _runway;
  }

  String get runway => _runway;
}
