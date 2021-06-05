import 'package:metar_dart/src/database/translations.dart';

class RecentWeather {
  final RegExpMatch _match;
  final _translations = SKY_TRANSLATIONS();
  String _description;
  String _precipitation;
  String _obscuration;
  String _other;

  RecentWeather(this._match) {
    final _desc = _match.namedGroup('descrip');
    final _pcpn = _match.namedGroup('precip');
    final _obsc = _match.namedGroup('obsc');
    final _othr = _match.namedGroup('other');

    _description = _desc != null ? _translations.WEATHER_DESC[_desc] : '';
    _precipitation = _pcpn != null ? _translations.WEATHER_PREC[_pcpn] : '';
    _obscuration = _obsc != null ? _translations.WEATHER_OBSC[_obsc] : '';
    _other = _othr != null ? _translations.WEATHER_OTHER[_othr] : '';
  }

  @override
  String toString() {
    final s = '$_description'
        ' $_precipitation'
        ' $_obscuration'
        ' $_other';
    return s.replaceAll(RegExp(r'\s{2,}'), ' ').trimLeft();
  }

  String get description => _description;
  String get precipitation => _precipitation;
  String get obscuration => _obscuration;
  String get other => _other;
}
