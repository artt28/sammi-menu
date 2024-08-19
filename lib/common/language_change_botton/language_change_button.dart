import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../constants/locales.dart';

class LanguageChangeButton extends StatelessWidget {
  final Function(BuildContext context, String newLocale) onLocaleChanged;
  final List<String> supportedLocales;

  const LanguageChangeButton({
    Key? key,
    required this.onLocaleChanged,
    required this.supportedLocales,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;
    final flagAssetPath = 'assets/img/flags/$currentLocale.png';

    return InkWell(
      onTap: () => _showLanguageModal(context),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: Image.asset(flagAssetPath),
      ),
    );
  }

  void _showLanguageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _LanguageModal(
        supportedLocales: supportedLocales,
        onLocaleChanged: onLocaleChanged,
      ),
    );
  }
}

class _LanguageModal extends StatelessWidget {
  final Function(BuildContext context, String newLocale) onLocaleChanged;
  final List<String> supportedLocales;

  const _LanguageModal({
    Key? key,
    required this.onLocaleChanged,
    required this.supportedLocales,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3.5, // Adjust this to fit the text better
        ),
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          final locale = supportedLocales[index];
          final flagAssetPath = 'assets/img/flags/$locale.png';

          return GestureDetector(
            onTap: () {
              onLocaleChanged(context, locale);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Image.asset(flagAssetPath),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Locales.getNameForLocale(locale),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black, // Ensure the text is visible
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class LanguageButtonWrapper extends StatelessWidget {
  final Widget child;
  final List<String> supportedLocales;
  final Function(BuildContext context, String newLocale) onLocaleChanged;

  const LanguageButtonWrapper({
    Key? key,
    required this.child,
    required this.supportedLocales,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 16,
          right: 16,
          child: LanguageChangeButton(
            supportedLocales: supportedLocales,
            onLocaleChanged: onLocaleChanged,
          ),
        ),
      ],
    );
  }
}
