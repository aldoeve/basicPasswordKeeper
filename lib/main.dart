import 'package:flutter/material.dart';

import 'utils/furina_app_consts.dart';
import 'views/furina_splash.dart';
import 'views/furina_setup.dart';
import 'views/furina_error_screen.dart';
import 'views/furina_home.dart';
import 'views/furina_psudo_random.dart';
import 'views/furina_random.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FurinaAppConsts.title,
      theme: ThemeData(
        colorScheme: FurinaAppConsts.colorScheme,
        useMaterial3: true,
      ),
      initialRoute: FurinaAppConsts.splash,
      routes: {
        FurinaAppConsts.home: (context)   => const FurinaHome(),
        FurinaAppConsts.splash: (context) => const FurinaSecretsSplashScreen(),
        FurinaAppConsts.setup: (context)  => const FurinaSetup(),
        FurinaAppConsts.unrecoverable: (context) => const FurinaErrorScreen(),
        FurinaAppConsts.psudoRandom: (context)   => const FurinaPsudoRandom(),
        FurinaAppConsts.random: (context) => const FurinaRandom(),
      },
    );
  }
}
