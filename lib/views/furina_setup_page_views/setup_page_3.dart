import 'package:flutter/material.dart';
import 'package:password_locker/utils/furina_app_consts.dart';

/// Getting a unique passphrase from the user.
class SetupPage3 extends StatefulWidget {

  // Vars to update the string secret the user types in.
  final Function(String) onSecretChanged;
  final String secret;
  final FocusNode textFocusNode;

  const SetupPage3({
    required this.onSecretChanged,
    required this.secret,
    required this.textFocusNode,
    super.key,
  });

  @override
  State<SetupPage3> createState() => _SetupPage3State();
}

class _SetupPage3State extends State<SetupPage3> {
  /// Observe and control user input for [secret].
  late TextEditingController _controller;

  @override
  void initState(){
    super.initState();
    _controller = TextEditingController(text: widget.secret);
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

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
                'Now enter your secret phrase that only you will remember. It will be used to generate constant sudo random passwords.\n\nHit done to save it!',
                style: TextStyle(
                  fontFamily: FurinaAppConsts.fontFamily,
                  fontSize: FurinaAppConsts.fontsize,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.0,
              child: TextField(
                focusNode: widget.textFocusNode,
                controller: _controller,
                onChanged: widget.onSecretChanged,
                decoration:const InputDecoration(
                  labelText: 'Secret here',
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
            ),
          ],
        )
      ),
    );
  }
}
