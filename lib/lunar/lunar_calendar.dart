import 'dart:math' as math;

/// Which country's lunar calendar to follow.
///
/// All four use the same rules, but each country works out "which day did
/// the new moon fall on" in its own time zone. When a new moon comes close
/// to midnight, the month starts a day earlier in one country than in
/// another, and sometimes a whole month ends up with a different number.
/// That is why Tết 1985 was a month earlier in Vietnam than in China, and
/// why Tết 2030 is on 2 February in Vietnam but 3 February in China.
enum LunarRegion {
  vietnam('vn', 7),
  china('cn', 8),
  korea('kr', 9),
  japan('jp', 9);

  const LunarRegion(this.code, this.utcOffsetHours);

  /// Short name used in saved data and in `assets/observances/<code>.json`.
  final String code;

  /// The meridian the calendar is computed for, as hours ahead of UTC.
  final int utcOffsetHours;

  static LunarRegion? fromCode(String? code) {
    for (final region in values) {
      if (region.code == code) return region;
    }
    return null;
  }
}

/// A day in a lunar calendar.
class LunarDate {
  const LunarDate(this.year, this.month, this.day, {this.isLeap = false});

  /// The lunar year, numbered like the solar year most of it falls in.
  final int year;

  /// 1 to 12.
  final int month;

  /// 1 to 30.
  final int day;

  /// True for the extra (leap) month that repeats [month].
  final bool isLeap;

  @override
  bool operator ==(Object other) =>
      other is LunarDate &&
      other.year == year &&
      other.month == month &&
      other.day == day &&
      other.isLeap == isLeap;

  @override
  int get hashCode => Object.hash(year, month, day, isLeap);

  @override
  String toString() => '$year-${isLeap ? 'L' : ''}$month-$day';
}

/// Converts between solar (Gregorian) days and one country's lunar calendar.
///
/// The astronomy follows Jean Meeus, "Astronomical Algorithms" (new moons:
/// chapter 49, sun: chapter 25), and the calendar rules follow Hồ Ngọc Đức's
/// well-known description of the Vietnamese calendar: a month starts on the
/// day of the new moon, the month holding the winter solstice is month 11,
/// and in a 13-month year the first month without a major solar term is the
/// leap month. Good for the years 1900 to 2100.
///
/// Solar days are plain [DateTime]s of which only year, month and day are
/// used.
class LunarCalendar {
  LunarCalendar._(this.region);

  static final _byOffset = <int, LunarCalendar>{};

  /// One shared instance per time zone, so the work done for one screen is
  /// reused by the next.
  factory LunarCalendar(LunarRegion region) {
    final shared = _byOffset[region.utcOffsetHours];
    if (shared != null && shared.region == region) return shared;
    final calendar = LunarCalendar._(region);
    // Korea and Japan share a meridian and therefore the cached numbers.
    if (shared != null) {
      calendar._newMoons = shared._newMoons;
      calendar._month11 = shared._month11;
    } else {
      _byOffset[region.utcOffsetHours] = calendar;
    }
    return calendar;
  }

  final LunarRegion region;

  var _newMoons = <int, int>{};
  var _month11 = <int, int>{};

  double get _zone => region.utcOffsetHours / 24;

  // ---------------------------------------------------------------------
  // Day numbers

  /// Julian day number of a Gregorian date.
  static int dayNumber(int year, int month, int day) {
    final a = (14 - month) ~/ 12;
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  static int dayNumberOf(DateTime day) =>
      dayNumber(day.year, day.month, day.day);

  /// The Gregorian date of a Julian day number, at local midnight.
  static DateTime dateOf(int dayNumber) {
    final a = dayNumber + 32044;
    final b = (4 * a + 3) ~/ 146097;
    final c = a - (b * 146097) ~/ 4;
    final d = (4 * c + 3) ~/ 1461;
    final e = c - (1461 * d) ~/ 4;
    final m = (5 * e + 2) ~/ 153;
    final day = e - (153 * m + 2) ~/ 5 + 1;
    final month = m + 3 - 12 * (m ~/ 10);
    final year = b * 100 + d - 4800 + m ~/ 10;
    return DateTime(year, month, day);
  }

  // ---------------------------------------------------------------------
  // Astronomy

  static const _rad = math.pi / 180;
  static const _synodicMonth = 29.530588861;

  /// TT minus UT in days (how far clocks have drifted from the Earth's
  /// rotation), for a moment given as Julian centuries from 2000.
  static double _deltaT(double t) {
    final year = 2000 + t * 100;
    double seconds;
    if (year < 1900) {
      final u = (year - 1860) / 100;
      seconds = 7.62 + 57.37 * u - 2517.54 * u * u + 16806.68 * u * u * u;
    } else if (year < 1920) {
      final u = year - 1900;
      seconds =
          -2.79 + 1.494119 * u - 0.0598939 * u * u + 0.0061966 * u * u * u;
    } else if (year < 1941) {
      final u = year - 1920;
      seconds = 21.20 + 0.84493 * u - 0.076100 * u * u + 0.0020936 * u * u * u;
    } else if (year < 1961) {
      final u = year - 1950;
      seconds = 29.07 + 0.407 * u - u * u / 233 + u * u * u / 2547;
    } else if (year < 1986) {
      final u = year - 1975;
      seconds = 45.45 + 1.067 * u - u * u / 260 - u * u * u / 718;
    } else if (year < 2005) {
      final u = year - 2000;
      seconds =
          63.86 +
          0.3345 * u -
          0.060374 * u * u +
          0.0017275 * u * u * u +
          0.000651814 * u * u * u * u +
          0.00002373599 * u * u * u * u * u;
    } else if (year < 2050) {
      final u = year - 2000;
      seconds = 62.92 + 0.32217 * u + 0.005589 * u * u;
    } else {
      final u = (year - 1820) / 100;
      seconds = -20 + 32 * u * u - 0.5628 * (2150 - year);
    }
    return seconds / 86400;
  }

  /// The moment of the [k]-th new moon since the one of 6 January 2000, as
  /// a Julian date in universal time.
  static double _newMoonMoment(int k) {
    final t = k / 1236.85;
    final t2 = t * t;
    final t3 = t2 * t;
    final t4 = t3 * t;
    var jde =
        2451550.09766 +
        _synodicMonth * k +
        0.00015437 * t2 -
        0.000000150 * t3 +
        0.00000000073 * t4;
    final e = 1 - 0.002516 * t - 0.0000074 * t2;
    final m =
        (2.5534 + 29.10535670 * k - 0.0000014 * t2 - 0.00000011 * t3) * _rad;
    final mp =
        (201.5643 +
            385.81693528 * k +
            0.0107582 * t2 +
            0.00001238 * t3 -
            0.000000058 * t4) *
        _rad;
    final f =
        (160.7108 +
            390.67050284 * k -
            0.0016118 * t2 -
            0.00000227 * t3 +
            0.000000011 * t4) *
        _rad;
    final omega =
        (124.7746 - 1.56375588 * k + 0.0020672 * t2 + 0.00000215 * t3) * _rad;

    jde +=
        -0.40720 * math.sin(mp) +
        0.17241 * e * math.sin(m) +
        0.01608 * math.sin(2 * mp) +
        0.01039 * math.sin(2 * f) +
        0.00739 * e * math.sin(mp - m) -
        0.00514 * e * math.sin(mp + m) +
        0.00208 * e * e * math.sin(2 * m) -
        0.00111 * math.sin(mp - 2 * f) -
        0.00057 * math.sin(mp + 2 * f) +
        0.00056 * e * math.sin(2 * mp + m) -
        0.00042 * math.sin(3 * mp) +
        0.00042 * e * math.sin(m + 2 * f) +
        0.00038 * e * math.sin(m - 2 * f) -
        0.00024 * e * math.sin(2 * mp - m) -
        0.00017 * math.sin(omega) -
        0.00007 * math.sin(mp + 2 * m) +
        0.00004 * math.sin(2 * mp - 2 * f) +
        0.00004 * math.sin(3 * m) +
        0.00003 * math.sin(mp + m - 2 * f) +
        0.00003 * math.sin(2 * mp + 2 * f) -
        0.00003 * math.sin(mp + m + 2 * f) +
        0.00003 * math.sin(mp - m + 2 * f) -
        0.00002 * math.sin(mp - m - 2 * f) -
        0.00002 * math.sin(3 * mp + m) +
        0.00002 * math.sin(4 * mp);

    // The fourteen small planetary corrections.
    const a = [
      [299.77, 0.107408, 325],
      [251.88, 0.016321, 165],
      [251.83, 26.651886, 164],
      [349.42, 36.412478, 126],
      [84.66, 18.206239, 110],
      [141.74, 53.303771, 62],
      [207.14, 2.453732, 60],
      [154.84, 7.306860, 56],
      [34.52, 27.261239, 47],
      [207.19, 0.121824, 42],
      [291.34, 1.844379, 40],
      [161.72, 24.198154, 37],
      [239.56, 25.513099, 35],
      [331.55, 3.592518, 23],
    ];
    for (var i = 0; i < a.length; i++) {
      var angle = a[i][0] + a[i][1] * k;
      if (i == 0) angle -= 0.009173 * t2;
      jde += a[i][2] / 1000000 * math.sin(angle * _rad);
    }
    return jde - _deltaT(t);
  }

  /// The sun's apparent longitude in degrees (0 to 360) at a Julian date in
  /// universal time.
  static double sunLongitude(double julianDate) {
    final t0 = (julianDate - 2451545.0) / 36525;
    final t = t0 + _deltaT(t0) / 36525;
    final t2 = t * t;
    final l0 = 280.46646 + 36000.76983 * t + 0.0003032 * t2;
    final m = (357.52911 + 35999.05029 * t - 0.0001537 * t2) * _rad;
    final c =
        (1.914602 - 0.004817 * t - 0.000014 * t2) * math.sin(m) +
        (0.019993 - 0.000101 * t) * math.sin(2 * m) +
        0.000289 * math.sin(3 * m);
    final omega = (125.04 - 1934.136 * t) * _rad;
    final apparent = l0 + c - 0.00569 - 0.00478 * math.sin(omega);
    return apparent - 360 * (apparent / 360).floorToDouble();
  }

  /// The day (in this country) on which the [k]-th new moon falls.
  int _newMoonDay(int k) =>
      _newMoons[k] ??= (_newMoonMoment(k) + 0.5 + _zone).floor();

  /// Which twelfth of the sun's yearly path (0 to 11) the sun is in when
  /// [dayNumber] begins in this country. The major solar terms are the
  /// borders between twelfths; the winter solstice is the start of number 9.
  int _sunSegmentAtStartOf(int dayNumber) =>
      (sunLongitude(dayNumber - 0.5 - _zone) / 30).floor();

  /// The first day of lunar month 11 (the month with the winter solstice)
  /// that falls in solar year [year].
  int _month11Start(int year) => _month11[year] ??= () {
    // The month must start on or before the day of the solstice, so the
    // sun must not yet be past it when the month's first day begins.
    final lastDay = dayNumber(year, 12, 31);
    var k = ((lastDay - 2451550.1) / _synodicMonth).floor() + 1;
    while (_newMoonDay(k) > lastDay) {
      k--;
    }
    if (_sunSegmentAtStartOf(_newMoonDay(k)) >= 9) k--;
    return _newMoonDay(k);
  }();

  /// The index `k` of the new moon that falls on [day].
  int _indexOfNewMoonOn(int day) {
    var k = ((day - 2451550.1) / _synodicMonth).round();
    while (_newMoonDay(k) < day) {
      k++;
    }
    while (_newMoonDay(k) > day) {
      k--;
    }
    return k;
  }

  /// For a 13-month stretch starting at the month-11 day [a11]: how many
  /// months after it the leap month comes.
  int _leapOffset(int a11) {
    final k = _indexOfNewMoonOn(a11);
    for (var i = 1; i < 14; i++) {
      // A month whose start and end lie in the same twelfth of the sun's
      // path holds no major solar term: that is the leap month.
      final start = _sunSegmentAtStartOf(_newMoonDay(k + i));
      final end = _sunSegmentAtStartOf(_newMoonDay(k + i + 1));
      if (start == end) return i;
    }
    return 13;
  }

  // ---------------------------------------------------------------------
  // Conversion

  /// The lunar date of a solar day.
  LunarDate fromSolar(DateTime solar) {
    final day = dayNumberOf(solar);
    var k = ((day - 2451550.1) / _synodicMonth).floor() + 1;
    while (_newMoonDay(k) > day) {
      k--;
    }
    final monthStart = _newMoonDay(k);

    var a11 = _month11Start(solar.year);
    var b11 = a11;
    int lunarYear;
    if (a11 >= monthStart) {
      lunarYear = solar.year;
      a11 = _month11Start(solar.year - 1);
    } else {
      lunarYear = solar.year + 1;
      b11 = _month11Start(solar.year + 1);
    }

    final monthsSince11 =
        _indexOfNewMoonOn(monthStart) - _indexOfNewMoonOn(a11);
    var month = monthsSince11 + 11;
    var isLeap = false;
    if (b11 - a11 > 365) {
      final leapOffset = _leapOffset(a11);
      if (monthsSince11 >= leapOffset) {
        month = monthsSince11 + 10;
        isLeap = monthsSince11 == leapOffset;
      }
    }
    if (month > 12) month -= 12;
    if (month >= 11 && monthsSince11 < 4) lunarYear -= 1;
    return LunarDate(lunarYear, month, day - monthStart + 1, isLeap: isLeap);
  }

  /// The first solar day of a lunar month, or null when [isLeap] is asked
  /// for but that year has no such leap month.
  int? _monthStart(int year, int month, bool isLeap) {
    final int a11;
    final int b11;
    if (month < 11) {
      a11 = _month11Start(year - 1);
      b11 = _month11Start(year);
    } else {
      a11 = _month11Start(year);
      b11 = _month11Start(year + 1);
    }
    var offset = month - 11;
    if (offset < 0) offset += 12;
    if (b11 - a11 > 365) {
      final leapOffset = _leapOffset(a11);
      var leapMonth = leapOffset - 2;
      if (leapMonth <= 0) leapMonth += 12;
      if (isLeap && month != leapMonth) return null;
      if (isLeap || offset >= leapOffset) offset += 1;
    } else if (isLeap) {
      return null;
    }
    return _newMoonDay(_indexOfNewMoonOn(a11) + offset);
  }

  /// The solar day of a lunar date, or null when that date does not exist
  /// (day 30 of a 29-day month, or a leap month the year does not have).
  DateTime? toSolar(LunarDate date) {
    final start = _monthStart(date.year, date.month, date.isLeap);
    if (start == null) return null;
    if (date.day < 1 || date.day > _lengthFrom(start)) return null;
    return dateOf(start + date.day - 1);
  }

  int _lengthFrom(int monthStart) {
    final k = _indexOfNewMoonOn(monthStart);
    return _newMoonDay(k + 1) - monthStart;
  }

  /// 29 or 30; 0 when the month does not exist.
  int daysInMonth(int year, int month, {bool isLeap = false}) {
    final start = _monthStart(year, month, isLeap);
    return start == null ? 0 : _lengthFrom(start);
  }

  /// The number of the month that is repeated in lunar year [year], or 0.
  int leapMonthOf(int year) {
    for (var month = 1; month <= 12; month++) {
      if (_monthStart(year, month, true) != null) return month;
    }
    return 0;
  }

  /// The solar day in [solarYear] on which the sun reaches [longitude]
  /// degrees, by this country's clock. 0 is the spring equinox, 15 is
  /// Qingming (Thanh minh), 180 the autumn equinox, 270 the winter solstice.
  DateTime solarTermDay(int solarYear, double longitude) {
    // The sun moves about 0.9856 degrees a day and is at 0 near 20 March.
    final guess = dayNumber(solarYear, 3, 20) + longitude / 0.98565;
    var moment = guess - 0.5;
    for (var i = 0; i < 6; i++) {
      var error = longitude - sunLongitude(moment);
      error -= 360 * (error / 360).roundToDouble();
      moment += error / 0.98565;
    }
    return dateOf((moment + 0.5 + _zone).floor());
  }
}
