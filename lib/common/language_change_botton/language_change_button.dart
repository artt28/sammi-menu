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
        width: 60, // 버튼 너비 제한
        height: 60, // 버튼 높이 제한
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            // 그림자 효과 추가
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          shape: BoxShape.circle, // 원형으로 변경
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
      height: 300,
      child: GridView.builder(
        // ListView.builder 대신 GridView.builder 사용
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 한 줄에 두 개씩 배치
          childAspectRatio: 5, // ListTile의 가로세로 비율 조절 (필요에 따라 변경)
        ),
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          final locale = supportedLocales[index];
          final flagAssetPath = 'assets/img/flags/$locale.png';

          return ListTile(
            leading: SizedBox(
              // 아이콘 크기 조절
              width: 32, // 원하는 크기로 조절 가능
              height: 32,
              child: Image.asset(flagAssetPath),
            ),
            title: Text(Locales.getNameForLocale(locale)),
            // 풀네임 가져오기
            onTap: () {
              onLocaleChanged(context, locale);
              Navigator.pop(context);
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ListTile 내부 여백 조절
            minVerticalPadding: 4, // ListTile 최소 세로 여백 조절
          );
        },
      ),
    );
  }
}

class LanguageButtonWrapper extends StatelessWidget {
  final Widget child; // AppBar 아래에 위치할 콘텐츠
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
        child, // 배경 이미지 또는 콘텐츠
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
