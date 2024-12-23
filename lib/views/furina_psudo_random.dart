import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:password_locker/utils/furina_exceptions.dart';
import 'package:password_locker/utils/furina_app_consts.dart';
import 'package:password_locker/utils/furina_generator.dart';

class FurinaPsudoRandom extends StatefulWidget {
  const FurinaPsudoRandom({super.key});

  @override
  State<FurinaPsudoRandom> createState() => _FurinaPsudoRandomState();
}

class _FurinaPsudoRandomState extends State<FurinaPsudoRandom> {
  /// Keeps track if secret is loaded.
  bool _isSecretLoaded = false;
  /// User's secret.
  String? _secret;
  /// Generated Password;
  String _createdPassword = " ";
  /// Check to see if the generator is done.
  bool _doneGenerating = false;
  /// Unknown error detected.
  bool _erorrDetected = false;
  /// User input
  String _purpose = " ";
  /// User hit enter.
  bool _enterHit = false;
  /// Text focus.
  final FocusNode _textFocusNode = FocusNode();
  /// User input controller.
  late TextEditingController _controller;

  /// Updates vars when the user hits done
  void _updateDone(){
    setState(() {
      _enterHit = true;
    });
    _generatePassword(_purpose);
  }

  // Updates based on user input.
  void updatePurpose(String newPurpose){
    setState(() {
      _purpose = newPurpose;
    });
  }

  /// Generates password.
  void _generatePassword(String purpose) {
    try{
      _createdPassword = FurinaGenerator(_secret, true).generatePassword(purpose);
    } on UnsupportedError catch (e){
      _createdPassword = e.message ?? r"No good source of entropy.";
    } on GeneratorNullError catch (e){
      _createdPassword = e.toString();
    }catch (e) {
      // Considered unrecoverable.
      _createdPassword = " ";
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

  /// Loads the users secret.
  Future<void> _recoverSecret() async {
    String? tempForSecrets;
    try{
      final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
      tempForSecrets = await secureStorage.read(key: FurinaAppConsts.secret);
      if (tempForSecrets == null){_isSecretLoaded = false;}
      else {_isSecretLoaded = true;}
    }catch (e){
      _isSecretLoaded = false;
    }

    if(_isSecretLoaded == false){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.of(context).pushReplacementNamed(FurinaAppConsts.unrecoverable);
      });
    }

    setState(() {
      if(_isSecretLoaded == true){
        _secret = tempForSecrets;
      }
    });
  }

  @override
  void initState(){
    super.initState();
    _controller = TextEditingController(text: _purpose);
    _recoverSecret();
  }

  @override
  void dispose(){
    _textFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSecretLoaded || (_enterHit && !_doneGenerating) ){
      return const Scaffold(
        backgroundColor: FurinaAppConsts.loadingclr,
        body: Center(
          child: SpinKitCircle(
            color: FurinaAppConsts.primaryclr,
          ),
        ),
      );
    }
    return  Scaffold(
      backgroundColor: FurinaAppConsts.primaryclr,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // Change from input to display.
          !_enterHit ?
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.0,
              child: TextField(
                focusNode: _textFocusNode,
                controller: _controller,
                onChanged: updatePurpose,
                decoration: const InputDecoration(
                  labelText: 'What do you want scrambled?',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black26,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            )
            :
            GestureDetector(
              onTap: () {
                if (_createdPassword.isNotEmpty){
                  Clipboard.setData(ClipboardData(text: _createdPassword));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard!'))
                  );
                }
              },
              child: Text(
                _createdPassword,
                style: const TextStyle(
                  fontFamily: FurinaAppConsts.fontFamily,
                  fontSize: FurinaAppConsts.fontsize,
                ),
              ),
            ),

            // Display enter Button.
            ! _enterHit ?
              GestureDetector(
                onTap: (){
                  FocusScope.of(context).requestFocus(_textFocusNode);
                  _updateDone();
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                    fontFamily: FurinaAppConsts.fontFamily,
                    fontSize: FurinaAppConsts.fontsize,
                  ),
                ),
              )
              :
              const Text(
                "WOW",
                style: TextStyle(
                  fontFamily: FurinaAppConsts.fontFamily,
                  fontSize: FurinaAppConsts.fontsize,
                ),
              ),

            // Change images.
            !_enterHit ?
              SizedBox(
                height: MediaQuery.of(context).size.height/2 - 55,
                child: Image.asset(
                  FurinaAppConsts.xilonen,
                  fit: BoxFit.fill,
                ),
              )
              :
              SizedBox(
                height: MediaQuery.of(context).size.height/2 - 55,
                child: Image.asset(
                  FurinaAppConsts.mualani,
                  fit: BoxFit.fill,
                ),
              ),
          ],
        ),
      ),
    );
  }
}