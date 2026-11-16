import 'package:ancestry_day/app.dart';
import 'package:ancestry_day/app_controller.dart';
import 'package:ancestry_day/data/observance_repository.dart';
import 'package:ancestry_day/lunar/lunar_calendar.dart';
import 'package:ancestry_day/models/memorial.dart';
import 'package:ancestry_day/screens/edit_memorial_screen.dart';
import 'package:ancestry_day/screens/settings_screen.dart';
import 'package:ancestry_day/services/app_store.dart';
import 'package:ancestry_day/services/reminder_notifier.dart';
import 'package:ancestry_day/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

/// Walks through the app as a user would, in Vietnamese, on 16 November
/// 2026 (mùng 8 tháng 10 năm Bính Ngọ).
void main() {
  late NoopReminderNotifier notifier;
  late AppController controller;

  Future<void> pumpApp(
    WidgetTester tester, {
    Map<String, Object> saved = const {},
  }) async {
    SharedPreferences.setMockInitialValues(saved);
    await initializeDateFormatting();
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    notifier = NoopReminderNotifier(supported: true);
    controller = AppController(
      observancesByRegion: {
        for (final region in LunarRegion.values)
          region: ObservanceRepository.parse(
            File('assets/observances/${region.code}.json').readAsStringSync(),
          ),
      },
      store: await AppStore.load(),
      notifier: notifier,
      texts: AppTexts(const Locale('vi')),
      clock: () => DateTime(2026, 11, 16, 9),
    );
    await tester.pumpWidget(
      AncestryDayApp(controller: controller, locale: const Locale('vi')),
    );
    await tester.pumpAndSettle();
  }

  const chosen = {'flutter.settings': '{"region":"vn"}'};

  testWidgets('the first screen asks which lunar calendar to follow', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(
      find.text('Gia đình bạn theo lịch âm của nước nào?'),
      findsOneWidget,
    );
    expect(controller.hasChosenRegion, isFalse);
    expect(notifier.lastSynced, isEmpty);

    await tester.ensureVisible(find.byKey(const ValueKey('region-cn')));
    await tester.tap(find.byKey(const ValueKey('region-cn')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('welcome-start')));
    await tester.tap(find.byKey(const ValueKey('welcome-start')));
    await tester.pumpAndSettle();

    expect(controller.region, LunarRegion.china);
    expect(find.byKey(const ValueKey('today-lunar')), findsOneWidget);
    expect(find.textContaining('Âm lịch Trung Quốc'), findsOneWidget);
    // Shared days (mùng một, rằm...) are scheduled straight away.
    expect(notifier.lastSynced, isNotEmpty);
  });

  testWidgets('today is shown in the lunar calendar', (tester) async {
    await pumpApp(tester, saved: chosen);
    expect(find.text('Mùng 8 tháng 10'), findsOneWidget);
    expect(find.textContaining('năm Bính Ngọ'), findsOneWidget);
    expect(find.text('Uống nước nhớ nguồn'), findsOneWidget);
  });

  testWidgets('adding a person schedules reminders on the right solar days', (
    tester,
  ) async {
    await pumpApp(tester, saved: chosen);
    await tester.tap(find.byKey(const ValueKey('empty-add')));
    await tester.pumpAndSettle();

    // Saving an empty form points out what is missing.
    await tester.ensureVisible(find.byKey(const ValueKey('save-person')));
    await tester.tap(find.byKey(const ValueKey('save-person')));
    await tester.pumpAndSettle();
    expect(find.text('Bạn chưa nhập tên.'), findsOneWidget);
    expect(controller.memorials, isEmpty);

    await tester.enterText(
      find.byKey(const ValueKey('field-name')),
      'Ông nội An',
    );
    await tester.enterText(find.byKey(const ValueKey('field-year')), '1998');
    Future<void> choose(String field, String value) async {
      await tester.ensureVisible(find.byKey(ValueKey(field)));
      await tester.tap(find.byKey(ValueKey(field)));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text(value),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text(value).last);
      await tester.pumpAndSettle();
    }

    await choose('field-day-null', '15');
    await choose('field-month-null', '10');
    // The coming years are previewed before saving.
    expect(find.text('Giỗ lần thứ 28'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('save-person')),
      200,
      scrollable: find
          .descendant(
            of: find.byType(EditMemorialScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byKey(const ValueKey('save-person')));
    await tester.pumpAndSettle();

    final saved = controller.memorials.single;
    expect(
      (saved.kind, saved.month, saved.day, saved.year),
      (CalendarKind.lunar, 10, 15, 1998),
    );
    expect(notifier.permissionRequests, 1);
    expect(find.text('Ông nội An'), findsWidgets);
    expect(find.text('Còn 7 ngày'), findsWidgets);

    // 15 tháng 10 năm Bính Ngọ is 23 November 2026: reminders on the day,
    // the day before, and a week before (which is today, already past 7:00).
    final mine = [
      for (final n in notifier.lastSynced)
        if (n.title.contains('Ông nội An')) n,
    ];
    expect(mine.map((n) => n.when).take(2), [
      DateTime(2026, 11, 22, 7),
      DateTime(2026, 11, 23, 7),
    ]);
    expect(mine[0].title, 'Ngày mai là ngày giỗ Ông nội An');
    expect(mine[1].title, 'Hôm nay là ngày giỗ Ông nội An');
    expect(mine[1].body, contains('15 tháng 10 âm lịch'));
    expect(notifier.lastSynced.length, lessThanOrEqualTo(60));
  });

  testWidgets('a person can be removed', (tester) async {
    await pumpApp(
      tester,
      saved: {
        ...chosen,
        'flutter.memorials': '[{"id":"a","name":"Bà Mai","kind":"lunar","month":1,"day":1,"year":2012}]',
      },
    );
    await tester.tap(find.text('Gia tiên'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('person-a')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('delete-person')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-delete')));
    await tester.pumpAndSettle();
    expect(controller.memorials, isEmpty);
    expect(notifier.lastSynced.any((n) => n.title.contains('Bà Mai')), isFalse);
  });

  testWidgets(
    'changing the calendar moves the days, and warns where countries differ',
    (tester) async {
      // Mùng 1 Tết: in 2030 Vietnam and China are a day apart.
      await pumpApp(
        tester,
        saved: {
          ...chosen,
          'flutter.memorials':
              '[{"id":"a","name":"Bà Mai","kind":"lunar","month":1,"day":1}]',
        },
      );
      expect(
        controller.nextOccurrence(controller.memorials.single).date,
        DateTime(2027, 2, 6),
      );
      await controller.chooseRegion(LunarRegion.korea);
      await tester.pumpAndSettle();
      expect(
        controller.nextOccurrence(controller.memorials.single).date,
        DateTime(2027, 2, 7),
      );
      expect(
        find.textContaining('theo lịch Việt Nam · Trung Quốc'),
        findsWidgets,
      );
    },
  );

  testWidgets('settings: lead days, shared days and the calendar comparison', (
    tester,
  ) async {
    await pumpApp(tester, saved: chosen);
    await tester.tap(find.byKey(const ValueKey('settings-button')));
    await tester.pumpAndSettle();

    final list = find
        .descendant(
          of: find.byType(SettingsScreen),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('lead-3')),
      200,
      scrollable: list,
    );
    await tester.tap(find.byKey(const ValueKey('lead-3')));
    await tester.pumpAndSettle();
    expect(controller.settings.leadDays, {0, 1, 3, 7});

    final before = notifier.lastSynced.length;
    final ram = find.byKey(const ValueKey('observance-vn-ram'));
    await tester.scrollUntilVisible(ram, 200, scrollable: list);
    await tester.tap(ram);
    await tester.pumpAndSettle();
    expect(controller.settings.observanceChoices['vn-ram'], isFalse);
    expect(notifier.lastSynced.length, lessThan(before));

    final see = find.byKey(const ValueKey('see-differences'));
    await tester.scrollUntilVisible(see, -200, scrollable: list);
    await tester.tap(see);
    await tester.pumpAndSettle();
    expect(find.text('Khi các lịch lệch nhau'), findsOneWidget);
    expect(find.textContaining('2030'), findsWidgets);
  });

  testWidgets(
    'the calendar tab shows lunar days and the language can be changed',
    (tester) async {
      await pumpApp(tester, saved: chosen);
      await tester.tap(find.text('Lịch âm'));
      await tester.pumpAndSettle();
      expect(find.text('Tháng 11 năm 2026'), findsOneWidget);
      expect(
        find.text('1/10'),
        findsOneWidget,
      ); // 9 November 2026 starts lunar month 10
      await tester.tap(find.byKey(const ValueKey('month-next')));
      await tester.pumpAndSettle();
      expect(find.text('Tháng 12 năm 2026'), findsOneWidget);
    },
  );

  testWidgets('every language builds every tab', (tester) async {
    for (final key in languageNames.keys) {
      SharedPreferences.setMockInitialValues({
        ...chosen,
        'flutter.memorials': '[{"id":"a","name":"An","kind":"lunar","month":1,"day":1,"year":2012}]',
      });
      await initializeDateFormatting();
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final c = AppController(
        observancesByRegion: const {},
        store: await AppStore.load(),
        notifier: NoopReminderNotifier(supported: true),
        texts: AppTexts(localeOfKey(key)),
        clock: () => DateTime(2030, 1, 20, 9),
      );
      await tester.pumpWidget(
        AncestryDayApp(
          key: ValueKey(key),
          controller: c,
          locale: localeOfKey(key),
        ),
      );
      await tester.pumpAndSettle();
      for (final icon in [
        Icons.menu_book_outlined,
        Icons.calendar_month_outlined,
      ]) {
        await tester.tap(find.byIcon(icon));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: key);
    }
  });
}
