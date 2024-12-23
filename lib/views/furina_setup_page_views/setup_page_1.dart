import 'package:flutter/material.dart';
import 'package:password_locker/utils/furina_app_consts.dart';

/// Welcome to app veiw.
class SetupPage1 extends StatelessWidget {
  const SetupPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FurinaAppConsts.primaryclr,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 35.0),
              child: const Text(
                textAlign: TextAlign.center,
                "Hello!\nI have come back to present the most wonderful password genorator.\nIt will, hopefully, help you keep a secret as well as I did. ^_^",
                style: TextStyle(
                  fontFamily: FurinaAppConsts.fontFamily,
                  fontSize: FurinaAppConsts.fontsize,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment(0.0, 0.75),
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  FurinaAppConsts.happyFurina,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
