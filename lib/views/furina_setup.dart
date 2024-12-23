import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/furina_app_consts.dart';
import 'furina_setup_page_views/setup_page_1.dart';
import 'furina_setup_page_views/setup_page_2.dart';
import 'furina_setup_page_views/setup_page_3.dart';

/// This view tells the user what the app is about and sets it up for them.
class FurinaSetup extends StatefulWidget {
  const FurinaSetup({super.key});

  @override
  State<FurinaSetup> createState() => _FurinaSetupState();
}

class _FurinaSetupState extends State<FurinaSetup> {
  // Keeps track of where in the introduction/setup we are in.
  final PageController _controller = PageController();
  final int _numberOfPages = 3;

  // Focus node for the input box.
  final FocusNode textFocusNode = FocusNode();

  // Passphrase that will be saved.
  String secret = '';

  bool _onLastpage = false;

  /// Replaces the current [secret] password with the argument. 
  /// Note this does not store the data in persistant storage.
  void updateSecret(String newSecret){
    setState(() {
      secret = newSecret;
    });
  }

  /// Stores the current [secret] and that its no longer the users
  /// first time in persistant storage.
  Future<void> _storeSecret() async {
    bool success = false;
    try{
      final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
      await secureStorage.write(key: FurinaAppConsts.secret, value: secret);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(FurinaAppConsts.firstSession, false);
      success = true;
    } on Exception catch (_){
      setState(() {
        FocusScope.of(context).requestFocus(textFocusNode);
        Navigator.of(context).pushReplacementNamed(FurinaAppConsts.unrecoverable);
      });
    }
    setState(() {
      if(success){
        FocusScope.of(context).requestFocus(textFocusNode);
        Navigator.of(context).pushReplacementNamed(FurinaAppConsts.home);
      }
    });
  }

  @override
  void dispose() {
    // Clean up the page indicator controller.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                if (index == (_numberOfPages - 1)){
                  _onLastpage = true;
                }
                else{
                  _onLastpage = false;
                }
              });
            },
            children: [
              const SetupPage1(),
              const SetupPage2(),
              SetupPage3(
                onSecretChanged: updateSecret,
                secret: secret,
                textFocusNode: textFocusNode,
              ),
            ],
          ),
          // Dot indicators
          Container(
            alignment: const Alignment(0.0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip button.
                !_onLastpage?
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(_numberOfPages-1);
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontFamily: FurinaAppConsts.fontFamily,
                    ),
                  ),
                )
                :
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(_numberOfPages-2);
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontFamily: FurinaAppConsts.fontFamily,
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller, 
                  count: _numberOfPages
                  ),
                // Next\Done button.
                !_onLastpage ?
                GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 500), 
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: FurinaAppConsts.fontFamily,
                    ),
                  ),
                ):
                GestureDetector(
                  onTap: () {
                    _storeSecret();
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      fontFamily: FurinaAppConsts.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}