import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app.dart';
import '../logic/occurrences.dart';
import '../lunar/lunar_calendar.dart';
import '../models/memorial.dart';
import '../widgets/eastern.dart';

/// Adds a person, or changes one already in the book.
class EditMemorialScreen extends StatefulWidget {
  const EditMemorialScreen({super.key, this.memorial});

  /// Null when adding.
  final Memorial? memorial;

  @override
  State<EditMemorialScreen> createState() => _EditMemorialScreenState();
}

class _EditMemorialScreenState extends State<EditMemorialScreen> {
  final _name = TextEditingController();
  final _relation = TextEditingController();
  final _year = TextEditingController();
  final _note = TextEditingController();

  CalendarKind? _kind;
  int? _day;
  int? _month;

  /// What the last "I only know the solar date" conversion found.
  DateTime? _convertedFrom;
  bool _convertedDiffers = false;

  /// Set after a failed save, so mistakes are pointed out only then.
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final m = widget.memorial;
    if (m != null) {
      _name.text = m.name;
      _relation.text = m.relation ?? '';
      _year.text = m.year?.toString() ?? '';
      _note.text = m.note ?? '';
      _kind = m.kind;
      _day = m.day;
      _month = m.month;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _relation.dispose();
    _year.dispose();
    _note.dispose();
    super.dispose();
  }

  int? get _yearValue => int.tryParse(_year.text.trim());

  bool _yearOk(DateTime today) =>
      _year.text.trim().isEmpty ||
      (_yearValue != null && _yearValue! >= 1800 && _yearValue! <= today.year);

  bool _dayOk(CalendarKind kind) {
    final day = _day;
    final month = _month;
    if (day == null || month == null) return false;
    if (kind == CalendarKind.lunar) return day <= 30;
    // 29 February is a real day, so a leap year is used for the check.
    return day <= DateTime(2024, month + 1, 0).day;
  }

  Memorial? _draft(CalendarKind kind, DateTime today) {
    if (!_dayOk(kind) || !_yearOk(today)) return null;
    String? filled(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    return Memorial(
      id: widget.memorial?.id ?? 'm${DateTime.now().microsecondsSinceEpoch}',
      name: _name.text.trim(),
      relation: filled(_relation),
      kind: kind,
      month: _month!,
      day: _day!,
      year: _yearValue,
      note: filled(_note),
    );
  }

  Future<void> _convert(LunarRegion region, DateTime today) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _convertedFrom ?? today,
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (picked == null) return;
    final lunar = LunarCalendar(region).fromSolar(picked);
    final differs = regionGroups.any((group) {
      final other = LunarCalendar(group.first).fromSolar(picked);
      return other.month != lunar.month || other.day != lunar.day;
    });
    setState(() {
      _day = lunar.day;
      _month = lunar.month;
      _year.text = '${lunar.year}';
      _convertedFrom = picked;
      _convertedDiffers = differs;
    });
  }

  Future<void> _save(CalendarKind kind, DateTime today) async {
    final draft = _draft(kind, today);
    if (draft == null || draft.name.isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    final navigator = Navigator.of(context);
    await AppScope.of(context).saveMemorial(draft);
    navigator.pop();
  }

  Future<void> _delete() async {
    final l10n = AppScope.textsOf(context).l10n;
    final controller = AppScope.of(context);
    final navigator = Navigator.of(context);
    final memorial = widget.memorial!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle(memorial.name)),
        content: Text(l10n.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const ValueKey('confirm-delete'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await controller.deleteMemorial(memorial.id);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final texts = AppScope.textsOf(context);
    final l10n = texts.l10n;
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final today = controller.today;
    final region = controller.region;
    // In Japan remembrance days are usually kept on the solar date.
    final kind =
        _kind ??
        (region == LunarRegion.japan ? CalendarKind.solar : CalendarKind.lunar);
    final lunarKind = kind == CalendarKind.lunar;
    final draft = _draft(kind, today);
    final regionName = texts.regionName(region);

    InputDecoration field(String label, {String? hint, String? error}) =>
        InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: error,
          filled: true,
          fillColor: tones.card,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: tones.line),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.memorial == null ? l10n.editAddTitle : l10n.editEditTitle,
        ),
        actions: [
          if (widget.memorial != null)
            IconButton(
              key: const ValueKey('delete-person'),
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          TextField(
            key: const ValueKey('field-name'),
            controller: _name,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
            decoration: field(
              l10n.fieldName,
              hint: l10n.fieldNameHint,
              error: _showErrors && _name.text.trim().isEmpty
                  ? l10n.errorName
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('field-relation'),
            controller: _relation,
            textCapitalization: TextCapitalization.sentences,
            decoration: field(l10n.fieldRelation),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final suggestion in l10n.relationSuggestions.split(','))
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text(suggestion),
                      visualDensity: VisualDensity.compact,
                      onPressed: () =>
                          setState(() => _relation.text = suggestion),
                    ),
                  ),
              ],
            ),
          ),
          SectionTitle(l10n.sectionDay),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<CalendarKind>(
              segments: [
                ButtonSegment(
                  value: CalendarKind.lunar,
                  label: Text(l10n.kindLunar),
                  icon: const Icon(Icons.nightlight_outlined),
                ),
                ButtonSegment(
                  value: CalendarKind.solar,
                  label: Text(l10n.kindSolar),
                  icon: const Icon(Icons.wb_sunny_outlined),
                ),
              ],
              selected: {kind},
              onSelectionChanged: (choice) => setState(() {
                _kind = choice.first;
                _convertedFrom = null;
              }),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: ValueKey('field-day-$_day'),
                  initialValue: _day,
                  isExpanded: true,
                  decoration: field(l10n.fieldDay),
                  menuMaxHeight: 320,
                  items: [
                    for (var d = 1; d <= (lunarKind ? 30 : 31); d++)
                      DropdownMenuItem(value: d, child: Text('$d')),
                  ],
                  onChanged: (value) => setState(() => _day = value),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<int>(
                  key: ValueKey('field-month-$_month'),
                  initialValue: _month,
                  isExpanded: true,
                  decoration: field(l10n.fieldMonth),
                  menuMaxHeight: 320,
                  items: [
                    for (var m = 1; m <= 12; m++)
                      DropdownMenuItem(value: m, child: Text('$m')),
                  ],
                  onChanged: (value) => setState(() => _month = value),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  key: const ValueKey('field-year'),
                  controller: _year,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onChanged: (_) => setState(() {}),
                  decoration: field(
                    l10n.fieldYear,
                    error: _yearOk(today) ? null : l10n.errorYear,
                  ),
                ),
              ),
            ],
          ),
          if (_showErrors && !_dayOk(kind))
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                l10n.errorDay,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            lunarKind ? l10n.lunarKindHint(regionName) : l10n.solarKindHint,
            style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
          ),
          if (lunarKind && _day == 30)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.shortMonthNote,
                style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
              ),
            ),
          if (lunarKind) ...[
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                key: const ValueKey('convert-solar'),
                onPressed: () => _convert(region, today),
                icon: const Icon(Icons.swap_horiz),
                label: Text(l10n.convertFromSolar),
              ),
            ),
            if (_convertedFrom case final from? when _dayOk(kind)) ...[
              Notice(
                icon: Icons.check_circle_outline,
                text: l10n.convertedNote(
                  texts.date(from),
                  '${texts.lunarDayMonth(_month!, _day!)} (${l10n.calendarOf(regionName)})',
                ),
              ),
              if (_convertedDiffers) ...[
                const SizedBox(height: 8),
                Notice(
                  icon: Icons.error_outline,
                  text: l10n.convertDifferNote,
                  strong: true,
                ),
              ],
            ],
          ],
          if (draft != null) ...[
            SectionTitle(l10n.previewTitle),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                child: Column(
                  children: [
                    for (final o in nextMemorialOccurrences(
                      draft,
                      region,
                      today,
                      count: 5,
                    ))
                      _PreviewRow(occurrence: o),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          TextField(
            key: const ValueKey('field-note'),
            controller: _note,
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: field(
              l10n.fieldNote,
              hint: l10n.fieldNoteHint,
            ).copyWith(alignLabelWithHint: true),
          ),
          const SizedBox(height: 20),
          FilledButton(
            key: const ValueKey('save-person'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => _save(kind, today),
            child: Text(l10n.save, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

/// One coming year: the solar date, and a warning when other countries'
/// calendars put the day elsewhere that year.
class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.occurrence});

  final MemorialOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final texts = AppScope.textsOf(context);
    final theme = Theme.of(context);
    final tones = Tones.of(context);
    final nth = occurrence.nth;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  texts.fullDate(occurrence.date),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (nth != null)
                Text(
                  texts.anniversary(nth),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: tones.muted,
                  ),
                ),
            ],
          ),
          for (final warning in texts.variantWarnings(occurrence))
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                warning,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
