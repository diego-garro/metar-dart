class ReportType {
  String _type = 'METAR';
  final _description = <String, String>{
    'METAR': 'Meteorological Aerodrome Report',
    'SPECI': 'Special Meteorological Aerodrome Report',
    'TAF': 'Terminal Aerodrome Forecast',
  };

  ReportType(RegExpMatch match) {
    _type = match.namedGroup('type');
  }

  String get type => _description[_type];
  set type(String value) =>
      _description.containsKey(value) ? _type = value : _type = _type;

  @override
  String toString() {
    return '--- Report type ---\n'
        ' * $type\n';
  }
}
