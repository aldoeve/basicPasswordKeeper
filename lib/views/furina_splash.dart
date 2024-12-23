import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/furina_app_consts.dart';

/// Generates the appropriate splash screen for the application.
class FurinaSecretsSplashScreen extends StatefulWidget {
  const FurinaSecretsSplashScreen({super.key});

  @override
  State<FurinaSecretsSplashScreen> createState() => _FurinaSecretsSplashScreenState();
}

class _FurinaSecretsSplashScreenState extends State<FurinaSecretsSplashScreen> with SingleTickerProviderStateMixin {
  /// Bool that tells if this is a first time user.
  bool? _usersFirstTime;

  // Used to control the animation of Furina.
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState(){
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _scaleAnimation = Tween<double>(begin: 0.1, end:1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.easeInOut,
      ),
    );
    
    // Redirect on completed animation.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        Navigator.of(context).pushReplacementNamed(FurinaAppConsts.home);
      }
    });
    if(_usersFirstTime == true) {_controller.forward();}
    _findOldSessionData();
  }

  @override
  void dispose() {
    // Clean up the animation controller.
    _controller.dispose();
    super.dispose();
  }

  /// Reads persistance data to populate [usersFirstTime].
  Future<void> _findOldSessionData() async{
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? firstTime = prefs.getBool(FurinaAppConsts.firstSession);
      firstTime ??= true;
      setState(() {
        _usersFirstTime = firstTime;
        if (_usersFirstTime == false){
          _controller.forward();
        }else{
          Navigator.of(context).pushReplacementNamed(FurinaAppConsts.setup);
        }
      });
    } on Exception catch (_){
      setState(() {
        Navigator.of(context).pushReplacementNamed(FurinaAppConsts.unrecoverable);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_usersFirstTime == null){
      // Displays the loading spinner if for when retriving the user data is taking longer.
      return const Scaffold(
        backgroundColor: FurinaAppConsts.loadingclr,
        body: Center(
          child: SpinKitCircle(
            color: FurinaAppConsts.primaryclr,
          ),
          ),
      );
    }
    
    return Scaffold(
      backgroundColor: FurinaAppConsts.primaryclr,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(FurinaAppConsts.pointingFurina),
              ),
            ),
          ],
        ),
        ),
    );
  }
}