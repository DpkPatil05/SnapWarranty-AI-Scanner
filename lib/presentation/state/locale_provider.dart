import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

@Riverpod(keepAlive: true)
class LocaleState extends _$LocaleState {
  static const String _localeKey = 'app_locale';

  @override
  Locale? build() {
    _loadLocale();
    return null; // Null means system default
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null && languageCode.isNotEmpty) {
      state = Locale(languageCode);
    }
  }

  Future<void> setLocale(String? languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    if (languageCode == null || languageCode.isEmpty) {
      await prefs.remove(_localeKey);
      state = null;
    } else {
      await prefs.setString(_localeKey, languageCode);
      state = Locale(languageCode);
    }
  }
}
