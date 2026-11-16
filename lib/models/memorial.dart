/// Which calendar a remembrance day follows.
enum CalendarKind { lunar, solar }

/// A person who has passed away and the day they are remembered on.
class Memorial {
  const Memorial({
    required this.id,
    required this.name,
    required this.kind,
    required this.month,
    required this.day,
    this.relation,
    this.year,
    this.note,
  });

  factory Memorial.fromJson(Map<String, dynamic> json) => Memorial(
    id: json['id'] as String,
    name: json['name'] as String,
    kind: json['kind'] == 'solar' ? CalendarKind.solar : CalendarKind.lunar,
    month: json['month'] as int,
    day: json['day'] as int,
    relation: json['relation'] as String?,
    year: json['year'] as int?,
    note: json['note'] as String?,
  );

  final String id;
  final String name;

  /// How the person is related, in the user's own words ("Ông nội").
  final String? relation;
  final CalendarKind kind;

  /// Month and day of passing in [kind]'s calendar. A lunar day is kept
  /// without its "leap month" mark: the day is observed in the regular month.
  final int month;
  final int day;

  /// Year of passing in [kind]'s calendar, when known. Only used to count
  /// "the n-th anniversary".
  final int? year;

  /// A few words of remembrance.
  final String? note;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'kind': kind.name,
    'month': month,
    'day': day,
    if (relation != null) 'relation': relation,
    if (year != null) 'year': year,
    if (note != null) 'note': note,
  };
}
