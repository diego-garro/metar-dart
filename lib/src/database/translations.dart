// Translations of the sky conditions codes into english

class SKY_TRANSLATIONS {
  Map<String, String> SKY_COVER = {
    'SKC': 'clear',
    'CLR': 'clear',
    'NSC': 'clear',
    'NCD': 'clear',
    'FEW': 'a few',
    'SCT': 'scattered',
    'BKN': 'broken',
    'OVC': 'overcast',
    '///': '',
    'VV': 'indefinite ceiling',
  };

  Map<String, String> CLOUD_TYPE = {
    'AC': 'altocumulus',
    'ACC': 'altocumulus castellanus',
    'ACSL': 'standing lenticulas altocumulus',
    'AS': 'altostratus',
    'CB': 'cumulonimbus',
    'CBMAM': 'cumulonimbus mammatus',
    'CCSL': 'standing lenticular cirrocumulus',
    'CC': 'cirrocumulus',
    'CI': 'cirrus',
    'CS': 'cirrostratus',
    'CU': 'cumulus',
    'NS': 'nimbostratus',
    'SC': 'stratocumulus',
    'ST': 'stratus',
    'SCSL': 'standing lenticular stratocumulus',
    'TCU': 'towering cumulus'
  };

// Translation of the present-weather codes into english

  Map<String, String> WEATHER_INT = {
    '-': 'light',
    '+': 'heavy',
    '-VC': 'nearby light',
    '+VC': 'nearby heavy',
    'VC': 'nearby',
  };

  Map<String, String> WEATHER_DESC = {
    'MI': 'shallow',
    'PR': 'partial',
    'BC': 'patches of',
    'DR': 'low drifting',
    'BL': 'blowing',
    'SH': 'showers',
    'TS': 'thunderstorm',
    'FZ': 'freezing',
  };

  Map<String, String> WEATHER_PREC = {
    'DZ': 'drizzle',
    'RA': 'rain',
    'SN': 'snow',
    'SG': 'snow grains',
    'IC': 'ice crystals',
    'PL': 'ice pellets',
    'GR': 'hail',
    'GS': 'snow pellets',
    'UP': 'unknown precipitation',
    '//': '',
  };

  Map<String, String> WEATHER_OBSC = {
    'BR': 'mist',
    'FG': 'fog',
    'FU': 'smoke',
    'VA': 'volcanic ash',
    'DU': 'dust',
    'SA': 'sand',
    'HZ': 'haze',
    'PY': 'spray',
  };

  Map<String, String> WEATHER_OTHER = {
    'PO': 'sand whirls',
    'SQ': 'squalls',
    'FC': 'funnel cloud',
    'SS': 'sandstorm',
    'DS': 'dust storm',
  };

  Map<String, String> WEATHER_SPECIAL = {
    '+FC': 'tornado',
  };

  Map<String, String> COLOR = {
    'BLU': 'blue',
    'GRN': 'green',
    'WHT': 'white',
  };

  // 3700
  Map<String, String> SEA_STATE = {
    '0': 'calm (glassy)',
    '1': 'calm (rippled)',
    '2': 'smooth (wavelets)',
    '3': 'slight',
    '4': 'moderate',
    '5': 'rough',
    '6': 'very rough',
    '7': 'high',
    '8': 'very high',
    '9': 'phenomenal',
  };

  // 0919
  Map<String, String> RUNWAY_DEPOSITS = {
    '0': 'clear and dry',
    '1': 'damp',
    '2': 'wet and water patches',
    '3': 'rime and frost covered (depth normally less than 1 mm)',
    '4': 'dry snow',
    '5': 'wet snow',
    '6': 'slush',
    '7': 'ice',
    '8': 'compacted or rolled snow',
    '9': 'frozen ruts or ridges',
    '/':
        'type of deposit not reported (e.g. due to runway clearance in progress),'
  };

  // 0519
  Map<String, String> RUNWAY_CONTAMINATION = {
    '1': 'less than 10%',
    '2': '11%-25%',
    '3': 'reserved',
    '4': 'reserved',
    '5': '26%-50%',
    '6': 'reserved',
    '7': 'reserved',
    '8': 'reserved',
    '9': '51%-100%',
    '/': 'not reported',
  };

  // 1079
  Map<String, String> DEPOSIT_DEPTH = {
    '00': 'less than 1 mm',
    '91': 'reserved',
    '92': '10 cm',
    '93': '15 cm',
    '94': '20 cm',
    '95': '25 cm',
    '96': '30 cm',
    '97': '35 cm',
    '98': '40 cm or more',
    '99':
        'runway(s) non-operational due to snow, slush, ice, large drifts or runway clearance, but depth not reported',
    '//': 'depth of deposit operationally not significant or not measurable',
  };

  // 0366
  Map<String, String> SURFACE_FRICTION = {
    '91': 'breaking action poor',
    '92': 'breaking action medium/poor',
    '93': 'breaking action medium',
    '94': 'breaking action medium/good',
    '95': 'breaking action good',
    '96': 'reserved',
    '97': 'reserved',
    '98': 'reserved',
    '99': 'unreliable',
    '//': 'breaking conditions not reported and/or runway not operational',
  };

// Translation of various remark codes into english

  Map<String, String> PRESSURE_TENDENCY = {
    '0': 'increasing, then decreasing',
    '1': 'increasing more slowly',
    '2': 'increasing',
    '3': 'increasing more quickly',
    '4': 'steady',
    '5': 'decreasing, then increasing',
    '6': 'decreasing more slowly',
    '7': 'decreasing',
    '8': 'decreasing more quickly',
  };

  Map<String, String> LIGHTNING_FREQUENCY = {
    'OCNL': 'occasional',
    'FRQ': 'frequent',
    'CONS': 'constant',
  };

  Map<String, String> LIGHTNING_TYPE = {
    'IC': 'intracloud',
    'CC': 'cloud-to-cloud',
    'CG': 'cloud-to-ground',
    'CA': 'cloud-to-air',
  };
}
