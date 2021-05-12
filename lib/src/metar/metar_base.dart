import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:metar_dart/src/database/translations.dart';
import 'package:tuple/tuple.dart';

import 'package:metar_dart/src/database/stations_db.dart';
import 'package:metar_dart/src/models/models.dart';
import 'package:metar_dart/src/units/units.dart';
import 'package:metar_dart/src/utils/capitalize_string.dart';
import 'package:metar_dart/src/utils/errors.dart';

/// Divide the METAR in three parts (if possible):
/// * `body`
/// * `trend`
/// * `remark`
List<String> _divideCode(String code) {
  String body, trend, rmk;
  final regexp = METAR_REGEX();
  int rmkIndex, trendIndex;

  if (regexp.TREND_RE.hasMatch(code)) {
    trendIndex = regexp.TREND_RE.firstMatch(code).start;
  }

  if (regexp.REMARK_RE.hasMatch(code)) {
    rmkIndex = regexp.REMARK_RE.firstMatch(code).start;
  }

  if (trendIndex == null && rmkIndex != null) {
    body = code.substring(0, rmkIndex - 1);
    rmk = code.substring(rmkIndex);
  } else if (trendIndex != null && rmkIndex == null) {
    body = code.substring(0, trendIndex - 1);
    trend = code.substring(trendIndex);
  } else if (trendIndex == null && rmkIndex == null) {
    body = code;
  } else {
    if (trendIndex > rmkIndex) {
      body = code.substring(0, rmkIndex - 1);
      rmk = code.substring(rmkIndex, trendIndex - 1);
      trend = code.substring(trendIndex);
    } else {
      body = code.substring(0, trendIndex - 1);
      rmk = code.substring(trendIndex, rmkIndex - 1);
      trend = code.substring(rmkIndex);
    }
  }

  return <String>[body, trend, rmk];
}

String _sanitizeWindshear(String code) {
  code = code.replaceFirst(RegExp(r'WS\sALL\sRWY'), 'WSALLRWY');

  final regex = RegExp(r'WS\sR(?<num>\d{2})(?<rwy>[CLR])?');
  for (var i = 1; i <= 3; i++) {
    if (regex.hasMatch(code)) {
      final match = regex.allMatches(code);
      final matches = match.elementAt(0);
      code = code.replaceFirst(
        regex,
        'WSR${matches.namedGroup("num")}${matches.namedGroup("rwy") ?? ""}',
      );
    }
  }

  return code;
}

String _sanitizeVisibility(String code) {
  final regex = RegExp(r'\s(?<int>\d+)\s(?<frac>\d/\dSM)\s');

  for (var i = 0; i < 2; i++) {
    if (regex.hasMatch(code)) {
      final match = regex.allMatches(code);
      final matches = match.elementAt(0);
      code = code.replaceFirst(
        regex,
        ' ${matches.namedGroup("int")}_${matches.namedGroup("frac")} ',
      );
    }
  }

  return code;
}

Map<String, String> _extractRunwayData(
  Runway runway,
) {
  return <String, String>{
    'name': runway.name,
    'units': 'meters',
    'low': runway.rvrLow,
    'lowRange': '${runway.lowRange.inMeters}',
    'high': runway.rvrHigh,
    'highRange': '${runway.highRange.inMeters}',
    'trend': runway.trend,
  };
}

String _extractSkyData(Tuple3<String, Length, String> layer) {
  final height =
      layer.item2.inFeet == 0 ? '' : ' at ${layer.item2.inFeet} feet';
  final cloud = layer.item3 != '' ? ' of ${layer.item3}' : '';
  return '${layer.item1}$height$cloud';
}

/// Metar model to parse the code for every station
class Metar {
  String _body, _trend, _rmk;
  String _string = '### BODY ###\n';
  String _code, _errorMessage;
  bool _correction = false;
  Modifier _modifier;
  ReportType _type;
  Station _station;
  int _month, _year;
  DateTime _time;
  Wind _wind, _trendWind;
  WindVariation _windVariation;
  Visibility _visibility, _trendVisibility, _minimumVisibility;
  Direction _minimumVisibilityDirection;
  bool _cavok, _trendCavok;
  final _weather = <Weather>[];
  final _trendWeather = <Weather>[];
  final _runway = <Runway>[];
  final _translations = SKY_TRANSLATIONS();
  final _sky = <Tuple3<String, Length, String>>[];
  final _trendSky = <Tuple3<String, Length, String>>[];
  Temperature _temperature, _dewpoint;
  Pressure _pressure;
  Map<String, String> _recentWeather;
  final _windshear = <String>[];
  Tuple2<Temperature, String> _seaState;
  Map<String, String> _runwayState;

  Metar(String code, {int utcMonth, int utcYear}) {
    if (code.isEmpty || code == null) {
      _errorMessage = 'metar code must be not null or empty string';
      throw ParserError(_errorMessage);
    }

    code = _sanitizeWindshear(code);
    code = _sanitizeVisibility(code);
    _code = code.trim().replaceAll(RegExp(r'\s+'), ' ').replaceAll('=', '');
    final dividedCodeList = _divideCode(_code);

    // Parts of the METAR code
    _body = dividedCodeList[0];
    _trend = dividedCodeList[1];
    _rmk = dividedCodeList[2];

    final now = DateTime.now().toUtc();
    if (utcMonth != null) {
      _month = utcMonth;
    } else {
      _month = now.month;
    }

    if (utcYear != null) {
      _year = utcYear;
    } else {
      _year = now.year;
    }

    _bodyParser();
  }

  /// Static method to get the current METAR report for a given station
  static Future<Metar> current(String icaoCode) async {
    final url =
        'http://tgftp.nws.noaa.gov/data/observations/metar/stations/${icaoCode.toUpperCase()}.TXT';
    final response = await http.get(url);
    final data = response.body.split('\n');

    final dateString = data[0].replaceAll('/', '-') + ':00';
    final date = DateTime.parse(dateString);

    return Metar(data[1], utcMonth: date.month, utcYear: date.year);
  }

  /// Get a resume of the report in the console with the toString() method
  @override
  String toString() {
    return _string;
  }

  /// Get the report as a Json format
  String toJson() {
    final map = <String, dynamic>{
      'code': _code,
      'type': _type.type,
      'time': _time.toString(),
      'station': _station.toMap(),
      'wind': <String, dynamic>{
        'units': 'knots',
        'direction': <String, String>{
          'degrees': '${_wind.direction?.directionInDegrees}',
          'cardinalPoint': '${_wind.direction?.cardinalDirection}',
        },
        'speed': '${_wind.speed?.inKnot}',
        'gust': '${_wind.gust?.inKnot}',
        'variation': <String, Map<String, String>>{
          'from': <String, String>{
            'degrees': '${_windVariation?.from?.directionInDegrees}',
            'cardinalPoint': '${_windVariation?.from?.cardinalDirection}',
          },
          'to': <String, String>{
            'degrees': '${_windVariation?.to?.directionInDegrees}',
            'cardinalPoint': '${_windVariation?.to?.cardinalDirection}',
          },
        },
      },
      'visibility': <String, dynamic>{
        'units': 'meters',
        'prevailing': '${_visibility?.value?.inMeters}',
        'minimum': <String, dynamic>{
          'visibility': '${_minimumVisibility?.value?.inMeters}',
          'direction': <String, String>{
            'degrees': '${_minimumVisibilityDirection?.directionInDegrees}',
            'cardinalPoint':
                '${_minimumVisibilityDirection?.cardinalDirection}',
          },
        },
        'runwayRanges': <Map<String, String>>[
          for (var rwy in _runway) _extractRunwayData(rwy)
        ],
      },
      'weather': <String>[
        for (var weather in _weather)
          weather.toList().join(' ').replaceAll(RegExp(r'\s{2,}'), ' ').trim(),
      ],
      'sky': <String>[
        for (var layer in _sky) _extractSkyData(layer),
      ],
      'temperatures': <String, String>{
        'units': '°C',
        'absolute': '${_temperature?.inCelsius}',
        'dewpoint': '${_dewpoint?.inCelsius}',
      },
      'pressure': <String, String>{
        'units': 'hPa',
        'value': '${_pressure?.inHPa}',
      },
      'suplementaryInfo': {
        'weather': _recentWeather?.values
            ?.toList()
            ?.join(' ')
            ?.replaceAll(RegExp(r'\s{2,}'), ' ')
            ?.trim(),
        'windshear': _windshear.join(' '),
        'seaState': <String, String>{
          'units': '°C',
          'temperature':
              _seaState != null ? '${_seaState.item1?.inCelsius}' : null,
          'state': _seaState != null ? _seaState.item2.toLowerCase() : null,
        },
        'runwayState': _runwayState?.values
            ?.toList()
            ?.join(' ')
            ?.replaceAll(RegExp(r'\s{2,}'), ' ')
            ?.trim(),
      }
    };

    return jsonEncode(map);
  }

  /// Here begins the body group handlers
  void _handleType(RegExpMatch match) {
    _type = ReportType(match);

    _string += _type.toString();
  }

  void _handleStation(RegExpMatch match) {
    final stationID = match.namedGroup('station');
    final station = getStation(stationID);

    _station = Station(
      station[0],
      station[1],
      station[2],
      station[3],
      station[4],
      station[5],
      station[6],
      station[7],
    );

    _string += _station.toString();
  }

  void _handleCorrection(RegExpMatch match) {
    _correction = true;

    _string += '--- Correction ---\n';
  }

  void _handleTime(RegExpMatch match) {
    final day = int.parse(match.namedGroup('day'));
    final hour = int.parse(match.namedGroup('hour'));
    final minute = int.parse(match.namedGroup('minute'));

    if (minute != 0) {
      _type.type = 'SPECI';
    }

    _time = DateTime(_year, _month, day, hour, minute);
    _string += '--- Time ---\n'
        ' * $_time\n';
  }

  void _handleModifier(RegExpMatch match) {
    _modifier = Modifier(match.namedGroup('mod'));

    _string += _modifier.toString();
  }

  void _handleWind(RegExpMatch match, {String section = 'body'}) {
    final wind = Wind(match);

    if (section == 'body') {
      _wind = wind;
    } else {
      _trendWind = wind;
    }

    _string += wind.toString();
  }

  void _handleWindVariation(RegExpMatch match) {
    _windVariation = WindVariation(match);

    _string += _windVariation.toString();
  }

  void _handleVisibility(RegExpMatch match, {String section = 'body'}) {
    final vis = Visibility(match);

    if (section == 'body') {
      _visibility = vis;
    } else {
      _trendVisibility = vis;
    }

    _string += '--- Visibility ---\n'
        ' * Prevailing: ${vis.toString()}\n';
  }

  void _handleMinimunVisibility(RegExpMatch match) {
    _minimumVisibility = Visibility(match);

    _string += ' * Secondary: ${_minimumVisibility.toString()}';
  }

  void _handleRunway(RegExpMatch match) {
    final runway = Runway(match);
    // adding the runway
    _runway.add(runway);

    if (_runway.last == _runway[0]) {
      _string += ' * Runway:\n';
    }
    _string += runway.toString();
  }

  void _handleWeather(RegExpMatch match, {String section = 'body'}) {
    final weather = Weather(match);

    if (section == 'body') {
      _weather.add(weather);
    } else {
      _trendWeather.add(weather);
    }

    if ((_weather.isNotEmpty && weather == _weather[0]) ||
        (_trendWeather.isNotEmpty && weather == _trendWeather[0])) {
      _string += '--- Weather ---\n';
    }

    _string += ' * ' + capitalize(weather.toString()) + '\n';
  }

  void _handleSky(RegExpMatch match, {String section = 'body'}) {
    Tuple3<String, Length, String> layer;
    Length heightValue;

    final cover = match.namedGroup('cover');
    final height = match.namedGroup('height');
    final cloud = match.namedGroup('cloud');

    if (height == '///' || height == null) {
      heightValue = Length.fromFeet();
    } else {
      heightValue = Length.fromFeet(value: double.parse(height) * 100.0);
    }

    layer = Tuple3(
      _translations.SKY_COVER[cover],
      heightValue,
      cloud != null ? _translations.CLOUD_TYPE[cloud] : '',
    );

    if (section == 'body') {
      _sky.add(layer);
    } else {
      _trendSky.add(layer);
    }

    if ((_sky.isNotEmpty && layer == _sky[0]) ||
        (_trendSky.isNotEmpty && layer == _trendSky[0])) {
      _string += '--- Sky ---\n';
    }

    _string += ' * ${capitalize(layer.item1)}'
        ' ${layer.item2.inFeet != 0.0 ? "at ${layer.item2.inFeet} feet" : ""}'
        ' ${layer.item3 != "" ? "of ${layer.item3}" : ""}\n';
  }

  void _handleTemperatures(RegExpMatch match) {
    final regex = RegExp(r'^\d{2}$');

    final tempSign = match.namedGroup('tsign');
    final temperature = match.namedGroup('temp');
    final dewptSign = match.namedGroup('dsign');
    final dewpoint = match.namedGroup('dewpt');

    Temperature defineTemperature(String sign, String temp) {
      if (sign == 'M' || sign == '-') {
        return Temperature.fromCelsius(value: double.parse('-$temp'));
      }

      return Temperature.fromCelsius(value: double.parse(temp));
    }

    if (regex.hasMatch(temperature)) {
      _temperature = defineTemperature(tempSign, temperature);
    }

    if (regex.hasMatch(dewpoint)) {
      _dewpoint = defineTemperature(dewptSign, dewpoint);
    }

    _string += '--- Temperatures ---\n'
        ' * Absolute: ${_temperature != null ? "${_temperature.inCelsius}°C" : "unknown"}\n'
        ' * Dewpoint: ${_dewpoint != null ? "${_dewpoint.inCelsius}°C" : "unknown"}\n';
  }

  void _handlePressure(RegExpMatch match) {
    final units = match.namedGroup('units');
    final press = match.namedGroup('press');
    final units2 = match.namedGroup('units2');

    if (press != '\//\//') {
      var pressAsDouble = double.parse(press);

      if (units == 'A' || units2 == 'INS') {
        _pressure = Pressure.fromInHg(value: pressAsDouble / 100.0);
      } else if (units == 'Q' || units == 'QNH') {
        _pressure = Pressure.fromHPa(value: pressAsDouble);
      } else if (units == 'SLP') {
        if (pressAsDouble < 500) {
          pressAsDouble = pressAsDouble / 10 + 1000;
        } else {
          pressAsDouble = pressAsDouble / 10 + 900;
        }
        _pressure = Pressure.fromMb(value: pressAsDouble);
      } else if (pressAsDouble > 2500.0) {
        _pressure = Pressure.fromInHg(value: pressAsDouble / 100);
      } else {
        _pressure = Pressure.fromMb(value: pressAsDouble);
      }
    }

    _string += '--- Pressure ---\n'
        ' * ${_pressure.inHPa} hPa\n';
  }

  void _handleRecentWeather(RegExpMatch match) {
    final description = match.namedGroup('descrip');
    final precipitation = match.namedGroup('precip');
    final obscuration = match.namedGroup('obsc');
    final other = match.namedGroup('other');

    _recentWeather = {
      'description':
          description != null ? _translations.WEATHER_DESC[description] : '',
      'precipitation': precipitation != null
          ? _translations.WEATHER_PREC[precipitation]
          : '',
      'obscuration':
          obscuration != null ? _translations.WEATHER_OBSC[obscuration] : '',
      'other': other != null ? _translations.WEATHER_OTHER[other] : '',
    };

    _string += '--- Recent Weather ---\n';

    final s = '${_recentWeather["description"]}'
        ' ${_recentWeather["precipitation"]}'
        ' ${_recentWeather["obscuration"]}'
        ' ${_recentWeather["other"]}';

    _string += ' * ' +
        capitalize(s.replaceAll(RegExp(r'\s{2,}'), ' ').trimLeft()) +
        '\n';
  }

  void _handleWindshear(RegExpMatch match) {
    final all = match.namedGroup('all');
    final number = match.namedGroup('num');
    final name = match.namedGroup('name');

    final rwyNames = {
      'R': 'right',
      'L': 'left',
      'C': 'center',
    };

    if (all != null) {
      _windshear.add(capitalize(all));
    } else {
      _windshear.add('$number${name != null ? " ${rwyNames[name]}" : ""}');
    }

    if (_windshear.length == 1) {
      _string += '--- Windshear ---\n';
    }

    _string += ' * ${capitalize(_windshear.last)}';
  }

  void _handleSeaState(RegExpMatch match) {
    Temperature temp;

    final sign = match.namedGroup('sign');
    final temperature = match.namedGroup('temp');
    final state = match.namedGroup('state');

    if (sign == 'M') {
      temp = Temperature.fromCelsius(value: double.parse('-' + temperature));
    } else {
      temp = Temperature.fromCelsius(value: double.parse(temperature));
    }

    _seaState = Tuple2(temp, capitalize(_translations.SEA_STATE[state]));

    _string += '--- Sea State ---\n'
        ' * Temperature: ${temp.inCelsius}°\n'
        ' * State: ${_seaState.item2}\n';
  }

  void _handleRunwayState(RegExpMatch match) {
    final number = match.namedGroup('num');
    var name = match.namedGroup('name');
    final deposit = match.namedGroup('deposit');
    final contamination = match.namedGroup('contamination');
    var depth = match.namedGroup('depth');
    var friction = match.namedGroup('friction');
    final snoclo = match.namedGroup('SNOCLO');
    final clrd = match.namedGroup('CLRD');

    if (name != null) {
      name = name
          .replaceFirst('L', ' left')
          .replaceFirst('R', ' right')
          .replaceFirst('C', ' center');
    }

    if (depth == null) {
      depth = '';
    } else if (int.parse(depth) == 1 || int.parse(depth) <= 90) {
      depth = '${int.parse(depth)} mm';
    } else {
      depth = _translations.DEPOSIT_DEPTH[depth];
    }

    if (friction == null) {
      friction = '';
    } else if (int.parse(friction) < 91) {
      friction = 'friction coefficient 0.$friction';
    } else {
      friction = _translations.SURFACE_FRICTION[friction];
    }

    _runwayState = {
      'runway': '${number ?? ""}${name != null ? " $name" : ""}',
      'deposit':
          deposit != null ? '${_translations.RUNWAY_DEPOSITS[deposit]}' : '',
      'contamination': contamination != null
          ? 'contamination ${_translations.RUNWAY_CONTAMINATION[contamination]}'
          : '',
      'depth': 'depth $depth',
      'friction': friction,
      'snoclo': snoclo != null
          ? 'aerodrome is closed due to extreme deposit of snow'
          : '',
      'clrd': clrd != null ? 'contaminants have ceased of exist' : '',
    };

    _string += '--- Runway State ---\n';
    if (snoclo != null) {
      _string += ' * ${capitalize(_runwayState["snoclo"])}\n';
    } else if (clrd != null) {
      _string += ' * ${capitalize(_runwayState["clrd"])}\n';
    } else {
      _string += ' * Deposit: ${_runwayState["deposit"]}\n'
          ' * Contamination: ${_runwayState["contamination"]}\n'
          ' * Depth: ${_runwayState["depth"]}\n'
          ' * Friction: ${_runwayState["friction"]}\n';
    }
  }

  // Method to parse the groups
  void _parseGroups(
    List<String> groups,
    List<Tuple2<RegExp, Function>> handlers, {
    String section = 'body',
  }) {
    Iterable<RegExpMatch> matches;
    var index = 0;

    groups.forEach((group) {
      for (var i = index; i < handlers.length; i++) {
        final handler = handlers[i];
        var obj;

        if (handler.item1.hasMatch(group)) {
          matches = handler.item1.allMatches(group);
          if (section == 'body') {
            handler.item2(matches.elementAt(0));
          } else {
            handler.item2(matches.elementAt(0), section: section);
          }

          index = i + 1;
          break;
        }

        // if (handlers.indexOf(handler) == handlers.length - 1) {
        //   _errorMessage = 'failed while processing "$group". Code: $_code';
        //   throw ParserError(_errorMessage);
        // }
      }
    });
  }
  // void _parseGroups(
  //   List<String> groups,
  //   List<List> handlers, {
  //   String section = 'body',
  // }) {
  //   Iterable<RegExpMatch> matches;
  //   var index = 0;

  //   groups.forEach((group) {
  //     for (var i = index; i < handlers.length; i++) {
  //       final handler = handlers[i];

  //       if (handler[0].hasMatch(group) && !handler[2]) {
  //         matches = handler[0].allMatches(group);
  //         if (section == 'body') {
  //           handler[1](matches.elementAt(0));
  //         } else {
  //           handler[1](matches.elementAt(0), section: section);
  //         }

  //         handler[2] = true;
  //         index = i + 1;
  //         break;
  //       }

  //       if (handlers.indexOf(handler) == handlers.length - 1) {
  //         _errorMessage = 'failed while processing "$group". Code: $_code';
  //         throw ParserError(_errorMessage);
  //       }
  //     }
  //   });
  // }

  void _bodyParser() {
    final handlers = <Tuple2<RegExp, Function>>[
      Tuple2(METAR_REGEX().TYPE_RE, _handleType),
      Tuple2(METAR_REGEX().STATION_RE, _handleStation),
      Tuple2(METAR_REGEX().COR_RE, _handleCorrection),
      Tuple2(METAR_REGEX().TIME_RE, _handleTime),
      Tuple2(METAR_REGEX().MODIFIER_RE, _handleModifier),
      Tuple2(METAR_REGEX().WIND_RE, _handleWind),
      Tuple2(METAR_REGEX().WINDVARIATION_RE, _handleWindVariation),
      Tuple2(METAR_REGEX().VISIBILITY_RE, _handleVisibility),
      Tuple2(METAR_REGEX().VISIBILITY_RE, _handleMinimunVisibility),
      Tuple2(METAR_REGEX().RUNWAY_RE, _handleRunway),
      Tuple2(METAR_REGEX().WEATHER_RE, _handleWeather),
      Tuple2(METAR_REGEX().WEATHER_RE, _handleWeather),
      Tuple2(METAR_REGEX().WEATHER_RE, _handleWeather),
    ];

    _parseGroups(_body.split(' '), handlers);
  }

  // void _bodyParser() {
  //   final handlers = [
  //     // [regex, handlerMethod, featureFound]
  //     [METAR_REGEX().TYPE_RE, _handleType, false],
  //     [METAR_REGEX().STATION_RE, _handleStation, false],
  //     [METAR_REGEX().COR_RE, _handleCorrection, false],
  //     [METAR_REGEX().TIME_RE, _handleTime, false],
  //     [METAR_REGEX().MODIFIER_RE, _handleModifier, false],
  //     [METAR_REGEX().WIND_RE, _handleWind, false],
  //     [METAR_REGEX().WINDVARIATION_RE, _handleWindVariation, false],
  //     [METAR_REGEX().OPTIONALVIS_RE, _handleOptionalVisibility, false],
  //     [METAR_REGEX().VISIBILITY_RE, _handleVisibility, false],
  //     [METAR_REGEX().SECVISIBILITY_RE, _handleMinimunVisibility, false],
  //     [METAR_REGEX().RUNWAY_RE, _handleRunway, false],
  //     [METAR_REGEX().WEATHER_RE, _handleWeather, false],
  //     [METAR_REGEX().WEATHER_RE, _handleWeather, false],
  //     [METAR_REGEX().WEATHER_RE, _handleWeather, false],
  //     [METAR_REGEX().SKY_RE, _handleSky, false],
  //     [METAR_REGEX().SKY_RE, _handleSky, false],
  //     [METAR_REGEX().SKY_RE, _handleSky, false],
  //     [METAR_REGEX().SKY_RE, _handleSky, false],
  //     [METAR_REGEX().TEMP_RE, _handleTemperatures, false],
  //     [METAR_REGEX().PRESS_RE, _handlePressure, false],
  //     [METAR_REGEX().PRESS_RE, _handlePressure, false],
  //     [METAR_REGEX().RECENT_RE, _handleRecentWeather, false],
  //     [METAR_REGEX().WINDSHEAR_RUNWAY_RE, _handleWindshear, false],
  //     [METAR_REGEX().WINDSHEAR_RUNWAY_RE, _handleWindshear, false],
  //     [METAR_REGEX().WINDSHEAR_RUNWAY_RE, _handleWindshear, false],
  //     [METAR_REGEX().SEASTATE_RE, _handleSeaState, false],
  //     [METAR_REGEX().RUNWAYSTATE_RE, _handleRunwayState, false],
  //   ];

  //   _parseGroups(_body.split(' '), handlers);
  // }

  // void _trendParser() {
  //   final handlers = [
  //     // [regex, handlerMethod, featureFound]
  //     [METAR_REGEX().WIND_RE, _handleWind, false],
  //     [METAR_REGEX().OPTIONALVIS_RE, _handleOptionalVisibility, false],
  //     [METAR_REGEX().VISIBILITY_RE, _handleVisibility, false],
  //     [METAR_REGEX().WEATHER_RE, _handleWeather, false],
  //     [METAR_REGEX().WEATHER_RE, _handleWeather, false],
  //     [METAR_REGEX().WEATHER_RE, _handleWeather, false],
  //     [METAR_REGEX().SKY_RE, _handleSky, false],
  //     [METAR_REGEX().SKY_RE, _handleSky, false],
  //     [METAR_REGEX().SKY_RE, _handleSky, false],
  //   ];

  //   _parseGroups(_trend.split(' '), handlers, section: 'trend');
  // }

  // Getters

  /// Get the body section of the report
  String get body => _body;

  /// Get the trend section of the report
  String get trend => _trend;

  /// Get the remark section of the report
  String get remark => _rmk;

  /// Get the type of the report
  String get type => _type.type;

  /// Get the station metadata
  /// * Name
  /// * ICAO
  /// * IATA
  /// * SYNOP
  /// * Longitude
  /// * Latitude
  /// * Elevation
  /// * Country
  Station get station => _station;

  /// Get if the report is a correction
  bool get correction => _correction;

  /// Get the datetime of the report
  DateTime get time => _time;

  /// Get the modifier of the report
  String get modifier => _modifier.modifier;

  /// Get the wind features of the report
  /// * direction
  ///   - inDegrees
  ///   - inRadians
  ///   - inGradians
  ///   - cardinalPoint
  /// * speed and gust
  ///   - inKnot
  ///   - inKilometerPerHour
  ///   - inMeterPerSecond
  ///   - inMilesPerHour
  /// Some times it can be null depending of station, be carefull
  Wind get wind => _wind;

  /// Get the wind variation directions from and to, both instaces of Direction
  /// *from/to
  ///   - inDegrees
  ///   - inRadians
  ///   - inGradians
  ///   - cardinalPoint
  ///
  /// Some times it can be null depending of station, be carefull
  WindVariation get windVariation => _windVariation;

  /// Get the visibility value and direction if provided, instances of Length
  /// and Direction respectively
  /// * value
  ///   - inMeters
  ///   - inKilometers
  ///   - inMiles
  ///   - inFeet
  /// * direction
  ///   - inDegrees
  ///   - inRadians
  ///   - inGradians
  ///   - cardinalPoint
  Visibility get visibility => _visibility;

  /// Get the CAVOK state of the report as a boolean
  bool get cavok => _cavok;

  /// Get the minimum visibility value and direction if provided, instances
  /// of Length and Direction respectively
  /// * value
  ///   - inMeters
  ///   - inKilometers
  ///   - inMiles
  ///   - inFeet
  /// * direction
  ///   - inDegrees
  ///   - inRadians
  ///   - inGradians
  ///   - cardinalPoint
  Visibility get minimumVisibility => _minimumVisibility;

  /// Get the runway ranges if provided as a list, every item has the values:
  ///
  /// These are String types
  /// * name
  /// * rvrLow
  /// * rvrHigh
  /// * trend
  ///
  /// These are Length types
  /// * lowRange
  ///   - inMeters
  ///   - inKilometers
  ///   - inMiles
  ///   - inFeet
  /// * highRange
  ///   - inMeters
  ///   - inKilometers
  ///   - inMiles
  ///   - inFeet
  List<Runway> get runway => _runway;

  /// Get the weather if provided as a list, every tem has the values:
  /// * intensity
  /// * description
  /// * precipitation
  /// * obscuration
  /// * other
  /// All the values are type String
  List<Weather> get weather => _weather;

  List<Tuple3<String, Length, String>> get sky => _sky;
  Temperature get temperature => _temperature;
  Temperature get dewpoint => _dewpoint;
  Pressure get pressure => _pressure;
  Map<String, String> get recentWeather => _recentWeather;
  List<String> get windshear => _windshear;
  Tuple2<Temperature, String> get seaState => _seaState;
  Map<String, String> get runwayState => _runwayState;

  // Trend getters

  /// Get the wind direction of the report
  /// * inDegrees
  /// * inRadians
  /// * inGradians
  /// * cardinalPoint
  /// Some times it can be null depending of station, be carefull
  Direction get trendWindDirection => _trendWind.direction;

  /// Get the medium wind speed of the report
  /// * inKnot
  /// * inKm/h
  /// * inM/s
  /// * inMiles/h
  /// Some times it can be null depending of station, be carefull
  Speed get trendWindSpeed => _trendWind.speed;

  /// Get the medium gust wind speed of the report
  /// * inKnot
  /// * inKm/h
  /// * inM/s
  /// * inMiles/h
  /// Some times it can be null depending of station, be carefull
  Speed get trendWindGust => _trendWind.gust;

  Visibility get trendVisibility => _trendVisibility;
  List<Weather> get trendWeather => _trendWeather;
  List<Tuple3<String, Length, String>> get trendSky => _trendSky;
}
