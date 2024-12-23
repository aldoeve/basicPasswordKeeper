import 'package:flutter/material.dart';
import 'package:password_locker/utils/furina_app_consts.dart';

class FurinaHome extends StatelessWidget {
  const FurinaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FurinaAppConsts.primaryclr,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => {Navigator.of(context).pushNamed(FurinaAppConsts.random)},
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                    width: 5.0,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Random Password",
                      style: TextStyle(
                        fontFamily: FurinaAppConsts.fontFamily,
                        fontSize: FurinaAppConsts.fontsize,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/2 - 55,
                      child: Image.asset(
                        FurinaAppConsts.mavuika,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom tile.
          Expanded(
            child: GestureDetector(
              onTap: () => {Navigator.of(context).pushNamed(FurinaAppConsts.psudoRandom)},
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                    width: 5.0,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Psudo Random Password",
                      style: TextStyle(
                        fontFamily: FurinaAppConsts.fontFamily,
                        fontSize: FurinaAppConsts.fontsize,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/2 - 55,
                      child: Image.asset(
                        FurinaAppConsts.yelan,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}