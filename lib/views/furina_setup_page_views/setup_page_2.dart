import 'package:flutter/material.dart';
import 'package:password_locker/utils/furina_app_consts.dart';

  /// Disclaimer about app.
class SetupPage2 extends StatelessWidget {
  const SetupPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FurinaAppConsts.primaryclr,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 35.0),
              child: const Text(
                textAlign: TextAlign.center,
                '!!DISCLAIMER!!\n This should not be a replacement for best password creation practices. It is intended for use on less sensitive throwaway accounts.',
                style: TextStyle(
                  fontFamily: FurinaAppConsts.fontFamily,
                  fontSize: FurinaAppConsts.fontsize,
                ),
              ),
            ),
            Image.asset(FurinaAppConsts.neuvillette),
          ],
        ),
      )
    );
  }
}