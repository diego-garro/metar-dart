class ParserError implements Exception {
  String _message = 'ParserError: ';

  ParserError(String message) {
    _message += message;
  }

  String get message => _message;

  @override
  String toString() {
    return _message;
  }
}

class ValueError implements Exception {
  String _message = 'ValueError: ';

  ValueError(String message) {
    _message += message;
  }

  String get message => _message;

  @override
  String toString() {
    return _message;
  }
}
