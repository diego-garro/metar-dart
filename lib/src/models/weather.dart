import 'package:metar_dart/src/database/translations.dart';

class Weather {
  final RegExpMatch _match;
  final _translations = SKY_TRANSLATIONS();
  String _intensity;
  String _description;
  String _precipitation;
  String _obscuration;
  String _other;

  Weather(this._match) {
    final _int = _match.namedGroup('intensity');
    final _des = _match.namedGroup('descrip');
    final _pre = _match.namedGroup('precip');
    final _obs = _match.namedGroup('obsc');
    final _oth = _match.namedGroup('other');

    _setIntensity(_int);
    _setDescription(_des);
    _setPrecipitation(_pre);
    _setObscuration(_obs);
    _setOther(_oth);
  }

  void _setIntensity(String value) {
    if (_translations.WEATHER_INT.containsKey(value)) {
      _intensity = _translations.WEATHER_INT[value];
    } else {
      _intensity = '';
    }
  }

  void _setDescription(String value) {
    if (_translations.WEATHER_DESC.containsKey(value)) {
      _description = _translations.WEATHER_DESC[value];
    } else {
      _description = '';
    }
  }

  void _setPrecipitation(String value) {
    if (_translations.WEATHER_PREC.containsKey(value)) {
      _precipitation = _translations.WEATHER_PREC[value];
    } else {
      _precipitation = '';
    }
  }

  void _setObscuration(String value) {
    if (_translations.WEATHER_OBSC.containsKey(value)) {
      _obscuration = _translations.WEATHER_OBSC[value];
    } else {
      _obscuration = '';
    }
  }

  void _setOther(String value) {
    if (_translations.WEATHER_OTHER.containsKey(value)) {
      _other = _translations.WEATHER_OTHER[value];
    } else {
      _other = '';
    }
  }

  @override
  String toString() {
    var s = '$_intensity'
        '   $_description'
        '   $_precipitation'
        '   $_obscuration'
        '   $_other';
    s = s.replaceAll(RegExp(r'\s{2,}'), ' ').trimLeft();

    return s;
  }

  List<String> toList() {
    return [
      _intensity,
      _description,
      _precipitation,
      _obscuration,
      other,
    ];
  }

  String get intensity => _intensity;
  String get description => _description;
  String get precipitation => _precipitation;
  String get obscuration => _obscuration;
  String get other => _other;
}
