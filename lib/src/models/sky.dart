import 'package:metar_dart/src/units/units.dart';
import 'package:metar_dart/src/database/translations.dart';
import 'package:metar_dart/src/utils/capitalize_string.dart';

class SkyLayer {
  final RegExpMatch _match;
  final _translations = SKY_TRANSLATIONS();
  String _cover;
  Length _height;
  String _cloud;

  SkyLayer(this._match) {
    final _cov = _match.namedGroup('cover');
    final _hgt = _match.namedGroup('height');
    final _cld = _match.namedGroup('cloud');

    _setCover(_cov);
    _setHeight(_hgt);
    _setCloud(_cld);
  }

  void _setCover(String value) {
    if (_translations.SKY_COVER.containsKey(value)) {
      _cover = _translations.SKY_COVER[value];
    } else {
      _cover = '';
    }
  }

  void _setHeight(String value) {
    if (value == '///' || value == null) {
      _height = Length.fromFeet();
    } else {
      _height = Length.fromFeet(value: double.parse(value) * 100.0);
    }
  }

  void _setCloud(String value) {
    if (_translations.CLOUD_TYPE.containsKey(value)) {
      _cloud = _translations.CLOUD_TYPE[value];
    } else {
      _cloud = '';
    }
  }

  @override
  String toString() {
    return '${capitalize(_cover)}' +
        (_height.inFeet != 0.0 ? ' at ${_height.inFeet} feet' : '') +
        (_cloud != null ? ' of $_cloud' : '');
  }

  String get cover => _cover;
  Length get height => _height;
  String get cloud => _cloud;
}
