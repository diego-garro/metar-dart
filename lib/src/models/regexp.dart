// Regular expressions to decode various groups of the METAR code

class METAR_REGEX {
  RegExp MISSING_RE = RegExp(r'^[M/]+$');

  RegExp TYPE_RE = RegExp(r'^(?<type>METAR|SPECI)$');

  RegExp COR_RE = RegExp(r'^(?<cor>COR)$');

  RegExp STATION_RE = RegExp(r'^(?<station>[A-Z][A-Z0-9]{3})$');

  RegExp TIME_RE = RegExp(r'^(?<day>\d{2})(?<hour>\d{2})(?<minute>\d{2})Z$');

  RegExp MODIFIER_RE =
      RegExp(r'^(?<mod>AUTO|FINO|NIL|TEST|CORR?|RTD|CC[A-G])$');

  RegExp WIND_RE = RegExp(
      r'^(?<dir>[\d]{3}|///|MMM|VRB|P)(?<speed>[\d]{2}|[/M]{2})(G(?<gust>\d{2}|[/M{2}]))?(?<units>KT|MPS)$');

  RegExp WINDVARIATION_RE = RegExp(r'^(?<from>\d{3})V(?<to>\d{3})$');

  RegExp OPTIONALVIS_RE = RegExp(r'^(?<opt>\d)$');

  RegExp VISIBILITY_RE = RegExp(
      r'^(?<vis>\d{4}|\//\//)|(?<extreme>M|P)?(?<visextreme>\d{1,2}|\d/\d)(?<units>SM|KM|M|U)|(?<cavok>CAVOK)$');

  RegExp SECVISIBILITY_RE = RegExp(r'^(?<vis>\d{4})(?<dir>[NSEW]([EW])?)$');

  RegExp RUNWAY_RE = RegExp(
      r'^(?<name>R\d{2}([RLC])?)/(?<rvrlow>[MP])?(?<low>\d{2,4})(V(?<rvrhigh>[MP])?(?<high>\d{2,4}))?(?<units>FT)?(?<trend>[NDU])?$');

  RegExp WEATHER_RE = RegExp(
      r'^((?<intensity>(-|\+|VC))?(?<descrip>MI|PR|BC|DR|BL|SH|TS|FZ)?((?<precip>DZ|RA|SN|SG|IC|PL|GR|GS|UP)|(?<obsc>BR|FG|FU|VA|DU|SA|HZ|PY)|(?<other>PO|SQ|FC|SS|DS|NSW|/))?)$');

  RegExp SKY_RE = RegExp(
      r'^(?<cover>VV|CLR|SCK|SCK|NSC|NCD|BKN|SCT|FEW|[O0]VC|///)(?<height>\d{3}|///)?(?<cloud>TCU|CB|///)?$');

  RegExp TEMP_RE = RegExp(
      r'^(?<tsign>M|-)?(?<temp>\d{2}|//|XX|MM)/(?<dsign>M|-)?(?<dewpt>\d{2}|//|XX|MM)$');

  RegExp PRESS_RE =
      RegExp(r'^(?<units>A|Q|QNH)?(?<press>\d{4}|\//\//)(?<units2>INS)?$');

  RegExp RECENT_RE = RegExp(
      r'^RE(?<descrip>MI|PR|BC|DR|BL|SH|TS|FZ)?(?<precip>DZ|RA|SN|SG|IC|PL|GR|GS|UP)?(?<obsc>BR|FG|VA|DU|SA|HZ|PY)?(?<other>PO|SQ|FC|SS|DS)?$');

  RegExp WINDSHEAR_RUNWAY_RE =
      RegExp(r'^WS(?<all>ALL)?(RWY|R(?<num>\d{2})(?<name>[RCL])?)$');

  RegExp SEASTATE_RE = RegExp(r'^W(?<sign>M)?(?<temp>\d{2})/S(?<state>\d)$');

  RegExp COLOR_RE =
      RegExp(r'^(BLACK)?(BLU|GRN|WHT|RED)\+?(/?(BLACK)?(BLU|GRN|WHT|RED)\+?)*');

  RegExp RUNWAYSTATE_RE = RegExp(
      r'^R(?<num>\d{2})?(?<name>[CLR])?/((?<deposit>\d|/)(?<contamination>\d|/)(?<depth>\d\d|//)(?<friction>\d\d|//)|(?<SNOCLO>SNOCLO)|(?<CLRD>CLRD//))$');
  //r'^((\d{2}) | R(\d{2})(RR?|LL?|C)?/?)((SNOCLO|CLRD(\d{2}|//)) | (\d|/)(\d|/)(\d{2}|//)(\d{2}|//))');

  RegExp TREND_RE = RegExp(r'(TEMPO|BECMG|FCST|NOSIG)');

  RegExp TRENDTIME_RE = RegExp(r'^(FM|TL|AT)(\d{2})(\d{2}\s+)');

  RegExp REMARK_RE = RegExp(r'((RMK(S)?)|NOSPECI)');

// Regular expressions for remark groups
  RegExp AUTO_RE = RegExp(r'^AO(\d)\s+');

  RegExp SEALVL_PRESS_RE = RegExp(r'^SLP(\d{3})');

  RegExp PEAK_WIND_RE =
      RegExp(r'^P[A-Z]\s+WND\s+(\d{3})(P?\d{3}?)/(\d{2})?(\d{2})');

  RegExp WIND_SHIFT_RE = RegExp(r'^WSHFT\s+(\d{2})?(\d{2})(\s+(FROPA))?');

  RegExp PRECIP_1HR_RE = RegExp(r'^P(\d{4})');

  RegExp PRECIP_24HR_RE = RegExp(r'^(6|7)(\d{4})');

  RegExp PRESS_3HR_RE = RegExp(r'^5([0-8])(\d{3})');

  RegExp TEMP_1HR_RE = RegExp(r'^T(1|2)(0|1)(\d{3})');

  RegExp TEMP_6HR_RE = RegExp(r'^(1|2)(0|1)(\d{3})');

  RegExp TEMP_24HR_RE = RegExp(r'^4(0|1)(\d{3})(0|1)(\d{3})');

  RegExp UNPARSED_RE = RegExp(r'(\S+)\s+');

  RegExp LIGHTNING_RE = RegExp(
      r'^((OCNL|FRQ|CONS)\s+)?LGT((IC|CC|CG|CA)*)( \s+(( OHD | VC | DSNT\s+ | \s+AND\s+ | [NSEW][EW]? (-[NSEW][EW]?)* )+) )?');

  RegExp TS_LOC_RE = RegExp(
      r'TS(\s+(( OHD | VC | DSNT\s+ | \s+AND\s+ | [NSEW][EW]? (-[NSEW][EW]?)* )+))?( \s+MOV\s+([NSEW][EW]?) )?');

  RegExp SNOWDEPTH_RE = RegExp(r'^4/(\d{3})');

  RegExp ICE_ACCRETION_RE = RegExp(r'^I([136])(\d{3})');
}
