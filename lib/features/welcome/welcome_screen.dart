import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/app_bar_gone.dart';
import '../../common/language_change_botton/language_change_button.dart';
import '../../constants/welcome_animation.dart';
import '../../router/app_router.dart';
import '../../common/bottom_nav_bar.dart';

class WelcomePage extends StatefulWidget {
  final bool openLanguageModal;

  const WelcomePage({
    Key? key,
    this.openLanguageModal = true,
  }) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  final List<String> _images = [
    'assets/img/welcome/ai1.jpeg',
    'assets/img/welcome/ai2.jpeg',
    'assets/img/welcome/ai3.jpeg',
  ];
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DurationConstants.fadeDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    _controller.forward();

    _timer = Timer.periodic(DurationConstants.imageChangeInterval, (_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _images.length;
          _controller.reset();
          _controller.forward();
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      body: LanguageButtonWrapper(
        supportedLocales: context.supportedLocales
            .map((locale) => locale.languageCode)
            .toList(),
        onLocaleChanged: (context, newLocale) {
          context.setLocale(Locale(newLocale));
        },
        initiallyOpen: widget.openLanguageModal,
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return AnimatedSwitcher(
                duration: DurationConstants.transitionDuration,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                    alignment: Alignment.center,
                  );
                },
                child: Image.asset(
                  _images[_currentIndex],
                  key: ValueKey<int>(_currentIndex),
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              );
            }),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'app_name'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'restaurant_description'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 200,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 10,
                  ),
                  onPressed: () => context.go(SGRoute.menu.route),
                  child: Text(
                    'menu'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 0),
    );
  }
}
