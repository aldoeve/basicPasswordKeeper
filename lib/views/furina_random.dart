import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:password_locker/utils/furina_app_consts.dart';
import 'package:password_locker/utils/furina_exceptions.dart';
import 'package:password_locker/utils/furina_generator.dart';

class FurinaRandom extends StatefulWidget {
  const FurinaRandom({super.key});

  @override
  State<FurinaRandom> createState() => _FurinaRandomState();
}

class _FurinaRandomState extends State<FurinaRandom> {
  
  /// Password that was generated.
  String? _createdPassword;
  /// An unknown error was encountered.
  bool _erorrDetected = false;
  /// Generator progress.
  bool _doneGenerating = false;

  /// Generates random password string and on error prepares to swap views.
  Future<void> _generatePassword() async {
    try{
      _createdPassword = FurinaGenerator(null, false).generatePassword(null);
    } on UnsupportedError catch (e){
      _createdPassword = e.message;
    } on GeneratorNullError catch (e){
      _createdPassword = e.toString();
    }catch (e) {
      // Considered unrecoverable.
      _createdPassword = null;
      _erorrDetected = true;
    }
    if(_erorrDetected){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.of(context).pushReplacementNamed(FurinaAppConsts.unrecoverable);
      });
    }else{
      setState(() {
        _doneGenerating = true;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _generatePassword();
  }

  @override
  Widget build(BuildContext context) {
    if (!_doneGenerating){
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (_createdPassword != null){
                  Clipboard.setData(ClipboardData(text: _createdPassword ?? ' '));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard!'))
                  );
                }
              },
              child: Text(
                _createdPassword ?? ' ',
                style: const TextStyle(
                  fontFamily: FurinaAppConsts.fontFamily,
                  fontSize: FurinaAppConsts.fontsize,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/2 - 55,
              child: Image.asset(
                FurinaAppConsts.huTao,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}