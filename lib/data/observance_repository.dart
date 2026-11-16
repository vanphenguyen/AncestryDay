import 'dart:convert';

import 'package:flutter/services.dart';

import '../lunar/lunar_calendar.dart';
import '../models/observance.dart';

/// Loads each country's shared days from `assets/observances/<code>.json`.
class ObservanceRepository {
  Future<Map<LunarRegion, List<Observance>>> loadAll() async => {
    for (final region in LunarRegion.values) region: await load(region),
  };

  Future<List<Observance>> load(LunarRegion region) async => parse(
    await rootBundle.loadString('assets/observances/${region.code}.json'),
  );

  static List<Observance> parse(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return [
      for (final item in json['items'] as List)
        Observance.fromJson(item as Map<String, dynamic>),
    ];
  }
}
