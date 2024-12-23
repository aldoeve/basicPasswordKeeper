import 'package:flutter/material.dart';

class FurinaAppConsts {
  // Persistant data.
  /// Data is a bool.
  static const String firstSession = 'firstSession';
  /// Data is a string.
  static const String secret = 'secret';

  // Text styles.
  static const String fontFamily = 'Modak';
  static const double fontsize   = 25.0;

  // Color settings.
  static const Color primaryclr = Colors.blueAccent;
  static const Color loadingclr = Colors.deepPurple;
  static const Color seedColor  = Color.fromARGB(255, 71, 162, 247); 
  static final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: seedColor);
  
  // Routes.
  static const String home   = '/';
  static const String splash = '/splashScreen';
  static const String setup  = '/setup';
  static const String unrecoverable = '/exiting';
  static const String psudoRandom   = '/psudoRandom';
  static const String random = '/random'; 

  // Images
  static const String pointingFurina = 'lib/assets/FurinaPointing.png';
  static const String happyFurina    = 'lib/assets/FurinaYippe.png';
  static const String neuvillette    = 'lib/assets/Neuvillette.png';
  static const String huTao          = 'lib/assets/Hu_Tao.png';
  static const String mavuika        = 'lib/assets/Mavuika.png';
  static const String yelan          = 'lib/assets/Yelan.png';
  static const String mualani        = 'lib/assets/Mualani.png';
  static const String xilonen        = 'lib/assets/Xilonen.png';

  // Misc.
  static const String title      = "Furina's Secrets";
  static const String forceClose = 'SystemNavigator.pop';
}