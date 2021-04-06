class Modifier {
  final String _modifier;
  final _description = <String, String>{
    'AUTO': 'Automatic report',
    'NIL': 'Missing report',
    'TEST': 'Testing report',
    'FINO': 'Missing report',
  };

  Modifier(this._modifier);

  String get modifier => _description[_modifier];

  @override
  String toString() {
    return '--- Modifier ---\n'
        ' * ${_description[_modifier]}';
  }
}
