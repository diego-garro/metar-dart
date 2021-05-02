import 'package:metar_dart/src/units/units.dart';

class WindVariation {
  final RegExpMatch _match;
  Direction _from;
  Direction _to;

  WindVariation(this._match) {
    _from = Direction.fromDegrees(value: _match.namedGroup('from'));
    _to = Direction.fromDegrees(value: _match.namedGroup('to'));
  }

  @override
  String toString() {
    return ' * Wind direction variation:\n'
        '   - From:\n'
        '     > Degrees: ${_from.directionInDegrees}\n'
        '     > Cardinal point: ${_from.cardinalDirection}\n'
        '   - To:\n'
        '     > Degrees: ${_to.directionInDegrees}\n'
        '     > Cardinal point: ${_to.cardinalDirection}\n';
  }

  // Getters
  Direction get from => _from;
  Direction get to => _to;
}
