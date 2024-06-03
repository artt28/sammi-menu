import 'package:flutter/material.dart';

class Locales {
  Locales._();

  static const Map<String, String> _localeNameMap = {
    'en': 'English',
    'ko': '한국어',
    'ja': '日本語',
    'fr': 'Français',
    'es': 'Español',
    'th': 'ไทย',
    'vi': 'Tiếng Việt',
    'zh': '中文',
  }; // 언어 코드와 풀네임 매핑

  static const supportedLocales = [
    // Locale 목록 상수
    Locale('en'),
    Locale('ko'),
    Locale('ja'),
    Locale('fr'),
    Locale('es'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
  ];

  static String getNameForLocale(String languageCode) {
    return _localeNameMap[languageCode] ?? languageCode; // 풀네임 반환 (없으면 코드 반환)
  }
}
