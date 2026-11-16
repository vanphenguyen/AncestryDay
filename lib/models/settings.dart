import '../lunar/lunar_calendar.dart';

/// A time of day, e.g. 07:00.
class ClockTime {
  const ClockTime(this.hour, this.minute);

  factory ClockTime.parse(String text) {
    final parts = text.split(':');
    return ClockTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  final int hour;
  final int minute;

  String get label =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// What the user has chosen. Saved on the phone only.
class Settings {
  const Settings({
    this.region,
    this.leadDays = defaultLeadDays,
    this.time = const ClockTime(7, 0),
    this.observanceDayBefore = true,
    this.observanceChoices = const {},
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    final days = {
      for (final d in json['leadDays'] as List? ?? defaultLeadDays)
        if (leadDayOptions.contains(d)) d as int,
    };
    return Settings(
      region: LunarRegion.fromCode(json['region'] as String?),
      leadDays: days.isEmpty ? defaultLeadDays : days,
      time: json['time'] is String
          ? ClockTime.parse(json['time'] as String)
          : const ClockTime(7, 0),
      observanceDayBefore: json['observanceDayBefore'] as bool? ?? true,
      observanceChoices: {
        for (final e in (json['observances'] as Map? ?? const {}).entries)
          e.key as String: e.value as bool,
      },
    );
  }

  /// How many days ahead a remembrance day can be announced. 0 is the day
  /// itself.
  static const leadDayOptions = [0, 1, 3, 7];
  static const defaultLeadDays = {0, 1, 7};

  /// The country whose lunar calendar is followed. Null until the user has
  /// picked one on the welcome screen: the app never guesses silently.
  final LunarRegion? region;

  /// When to remind about a person's remembrance day.
  final Set<int> leadDays;

  /// The time of day reminders arrive.
  final ClockTime time;

  /// Whether shared days (rằm, mùng một, festivals) are also announced the
  /// day before, to leave time to prepare.
  final bool observanceDayBefore;

  /// Shared days the user switched on or off, by observance id. Others
  /// follow their default.
  final Map<String, bool> observanceChoices;

  Settings copyWith({
    LunarRegion? region,
    Set<int>? leadDays,
    ClockTime? time,
    bool? observanceDayBefore,
    Map<String, bool>? observanceChoices,
  }) => Settings(
    region: region ?? this.region,
    leadDays: leadDays ?? this.leadDays,
    time: time ?? this.time,
    observanceDayBefore: observanceDayBefore ?? this.observanceDayBefore,
    observanceChoices: observanceChoices ?? this.observanceChoices,
  );

  Map<String, dynamic> toJson() => {
    if (region != null) 'region': region!.code,
    'leadDays': leadDays.toList()..sort(),
    'time': time.label,
    'observanceDayBefore': observanceDayBefore,
    'observances': observanceChoices,
  };
}
