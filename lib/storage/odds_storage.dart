import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OddsStorage {
  static const String _key = 'selected_odds';

  static Future<void> saveSelectedOdds(Map<int, String> odds) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      odds.map((key, value) => MapEntry(key.toString(), value)),
    );
    await prefs.setString(_key, encoded);
    debugPrint('📌 Saved selected odds: $odds');
  }

  static Future<Map<int, String>> loadSelectedOdds() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) {
      debugPrint('⚠️ No selected odds found in storage');
      return {};
    }

    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      final result = decoded.map<int, String>(
        (key, value) => MapEntry(int.parse(key), value.toString()),
      );

      debugPrint('✅ Loaded selected odds from storage: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Failed to decode selected odds: $e');
      return {};
    }
  }
}
