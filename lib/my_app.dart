import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/theme/theme_logic.dart';
import 'config/theme/theme_ui_model.dart';
import 'di/components/service_locator.dart';
import 'router/app_router.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final ThemeUiModel currentTheme = ref.watch(themeLogicProvider);
    return MaterialApp.router(
      routerConfig: getIt<SGGoRouter>().getGoRouter,
      title: "영동삼미숯불갈비",
      theme: FlexThemeData.light(
        scheme: FlexScheme.deepBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.deepBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      themeMode: currentTheme.themeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return LanguageChangeListener(child: child!);
      },
    );
  }
}

class LanguageChangeListener extends StatefulWidget {
  final Widget child;

  const LanguageChangeListener({Key? key, required this.child})
      : super(key: key);

  @override
  _LanguageChangeListenerState createState() => _LanguageChangeListenerState();
}

class _LanguageChangeListenerState extends State<LanguageChangeListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.locale; // This will trigger a rebuild when the locale changes
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}
