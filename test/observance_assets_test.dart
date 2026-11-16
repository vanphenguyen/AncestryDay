import 'dart:io';

import 'package:ancestry_day/data/observance_repository.dart';
import 'package:ancestry_day/logic/occurrences.dart';
import 'package:ancestry_day/lunar/lunar_calendar.dart';
import 'package:ancestry_day/texts.dart';
import 'package:flutter_test/flutter_test.dart';

/// Checks assets/observances/*.json. Run after editing the data.
void main() {
  final ids = <String>{};
  for (final region in LunarRegion.values) {
    test('${region.code}.json is complete', () {
      final file = File('assets/observances/${region.code}.json');
      expect(file.existsSync(), isTrue);
      final items = ObservanceRepository.parse(file.readAsStringSync());
      expect(items, isNotEmpty);
      for (final item in items) {
        expect(ids.add(item.id), isTrue, reason: 'id trùng: ${item.id}');
        expect(item.id.startsWith('${region.code}-'), isTrue, reason: item.id);
        for (final language in languageNames.keys) {
          expect(
            item.title.byLanguage[language]?.trim(),
            isNotEmpty,
            reason: '${item.id} thiếu chữ "$language"',
          );
        }
        // Every rule must give at least one day a year.
        final days = observanceOccurrences(
          item,
          region,
          DateTime(2026, 1, 1),
          DateTime(2026, 12, 31),
        );
        expect(days, isNotEmpty, reason: item.id);
      }
    });
  }
}
