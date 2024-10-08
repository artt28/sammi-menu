// ignore_for_file: always_put_control_body_on_new_line

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'constants/locales.dart';
import 'constants/strings.dart';
import 'data/hive/hive.dart';
import 'data/hive/hive_helper.dart';
import 'di/components/service_locator.dart';
import 'my_app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

/// Try using const constructors as much as possible!

void main() async {
  /// Initialize packages
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();
  await initHive();
  await configureDependencies();
  await setPreferredOrientations();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase 인증 추가
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'user@naver.com',
      password: '123321',
    );
    print('Firebase 인증 성공');
  } catch (e) {
    print('Firebase 인증 실패: $e');
  }

  getIt<HiveHelper>().initHive();
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }

  runApp(
    EasyLocalization(
      supportedLocales: Locales.supportedLocales, // Locales 클래스에서 가져옴
      path: Strings.localizationsPath,
      fallbackLocale: const Locale('en', ''),
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );

  /// Add this line to get the error stack trace in release mode
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}
