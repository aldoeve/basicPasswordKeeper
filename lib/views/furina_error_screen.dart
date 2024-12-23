import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:password_locker/utils/furina_app_consts.dart';

/// This closes down the app since there has been an issue that can not be recovered from.
class FurinaErrorScreen extends StatelessWidget {
  const FurinaErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 4), () {
      SystemChannels.platform.invokeMethod(FurinaAppConsts.forceClose);
    });

    return Scaffold(
      backgroundColor: FurinaAppConsts.primaryclr,
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          "You are not supposed to be here. Some error was detected and app is closing in a bit.",
          style: TextStyle(
            fontFamily: FurinaAppConsts.fontFamily,
            fontSize: FurinaAppConsts.fontsize,
          ),
        ),
      ),
    );
  }
}