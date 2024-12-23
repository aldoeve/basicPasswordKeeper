import 'furina_exceptions.dart';
import 'dart:math';

import 'furina_generator_enums.dart';

/// Creates both fully random and psudo-random passwords.
/// Requires a string(users secret) if a fully random password is desired.
class FurinaGenerator{
  /// User's secret.
  final String? _userPhrase;
  /// Hashed [_userPhrase].
  int _hashed = 78;
  /// True means the instance will create a psudo password.
  final bool _isPsudo;
  /// Random source;
  final Random _secure = Random.secure();
  /// Index where the requirements have been met.
  List<int> _passwordStatus = [-1, -1, -1, -1];
  /// Password length.
  final _desiredLength = 12;
  /// Password.
  String _password = r"";

  /// Exceptions:
  /// 
  ///   [UnsupportedError] on no cryptographically secure source of random numbers. 
  FurinaGenerator(String? userPhrase, bool isPsudo): 
    _userPhrase = userPhrase, 
    _isPsudo = isPsudo;

  /// Creates a simple hash given a string.
  int _hashPhrase(String phrase){
    int hash = 0;
    for (int i = 0; i < phrase.length; ++i){
      hash = ((hash << 5) - hash) + phrase.codeUnitAt(i);
      hash = hash & hash;
    }
    return hash;
  }

  /// Resets the requirements to create another password.
  void _resetRequirementsAndPassword(){
    _passwordStatus = [-1, -1, -1, -1];
    _password = r"";
    return;
  }

  /// Checks what type of requirement was met and logs it.
  void _checkIfRequirementMet(int generatedInt, int currentPasswordIndex){
    if (generatedInt < 48){
      _passwordStatus[Requirements.specialChars.i] = currentPasswordIndex;
    }
    else if (generatedInt < 58){
      _passwordStatus[Requirements.number.i] = currentPasswordIndex;
    }
    else if (generatedInt < 65){
      _passwordStatus[Requirements.specialChars.i] = currentPasswordIndex;
    }
    else if (generatedInt < 91){
      _passwordStatus[Requirements.upperCase.i] = currentPasswordIndex;
    }
    else if (generatedInt < 97){
      _passwordStatus[Requirements.specialChars.i] = currentPasswordIndex;
    }
    else if (generatedInt < 123){
      _passwordStatus[Requirements.lowerCase.i] = currentPasswordIndex;
    }
    return;
  }

  /// Checks to see if the chosen location is already where a requirement was met.
  bool _mapped(int loc){
    return  (_passwordStatus[Requirements.lowerCase.i] == loc)||
            (_passwordStatus[Requirements.number.i] == loc)||
            (_passwordStatus[Requirements.specialChars.i] == loc)||
            (_passwordStatus[Requirements.upperCase.i] == loc);
  }

  /// Modifies near final random password to ensure that all the requirements are meet.
  void _enforceRandomRequirements(){
    int locationToChange = _secure.nextInt(12);
    int min = 0;
    int max = 1;
    for(int i = 0; i < _passwordStatus.length; ++i){
      while(_mapped(locationToChange)){locationToChange = _secure.nextInt(12);}
      switch(Requirements.values[i % Requirements.values.length]){
        case Requirements.lowerCase:
          min = 97;
          max = 26;
        case Requirements.upperCase:
          min = 65;
          max = 26;
        case Requirements.number:
          min = 48;
          max = 10;
        case Requirements.specialChars:
          min = 36;
          max = 4;
      }
      _password = _password.replaceRange(locationToChange, locationToChange + 1,
                                              String.fromCharCode(_secure.nextInt(max) + min));
    }
    return;
  }

  /// Returns a random password string.
  void _randomPassword(){
    _resetRequirementsAndPassword();

    int generatedInt = 0;

    // Populate the string.
    for(int i=0; i <= _desiredLength; ++i){
      generatedInt = _secure.nextInt(90) + 33;
      _checkIfRequirementMet(generatedInt, i);
      _password += String.fromCharCode(generatedInt);
    }

    // Enforce Requirements.
    _enforceRandomRequirements();

    return;
  }

  /// Srabmles a number to make it look random.
  int _scramble(int x){
    x = ((x >> 16) ^ x) * 0x45d9f3b ^ _hashed;
    x = ((x >> 16) ^ x) * 0x45d9f3b ^ _hashed;
    x = (x >> 16) ^ x ^ _hashed;
    return x;
  }

  /// Modifies the current psudo password if not all the requirements have been meet.
  void _checkPsudo(){
    bool upper = false;
    bool lower = false;
    // Used to check if the there is an upper and lower case.
    int temp = 0;

    for(int i = 0; i < _password.length; ++i){
        if(upper && lower) break;
        temp = _password[i].codeUnitAt(0);
        if(temp > 64 && temp < 91) upper = true;
        if(temp > 96 && temp < 123) lower = true;
    }
    if(upper == false){_password += _userPhrase?[0] ?? 'A' ;}
    if(lower == false){_password += _userPhrase?[1] ?? 'b';}
  }

  /// Returns a psudo password string.
  void _psudoPassword(String purpose){
    _resetRequirementsAndPassword();
    if (_userPhrase != null){
      _hashed = _hashPhrase(_userPhrase);
    }

    Set<String> seen = {};
    int special = purpose[0].codeUnitAt(0) % 2;
    int numbers = purpose[1].codeUnitAt(0) % 3;
    int scrambledNum = 0;
    int purposeLoc = 0;

    for(int i = 0; i < _desiredLength; ++i){
      if (i >= purpose.length){
        purposeLoc = i % purpose.length;
      }else{
        purposeLoc = i;
      }
      scrambledNum = _scramble(purpose[purposeLoc].codeUnitAt(0));
      if (seen.contains(purpose[purposeLoc])){
        scrambledNum += 1;
      }
      seen.add(purpose[purposeLoc]);
      scrambledNum %= 123;
      if(scrambledNum < 97) scrambledNum += 33;
      if(scrambledNum > 90 && scrambledNum < 97) scrambledNum += 6;
      if(scrambledNum >= 126){
        scrambledNum %= 93 ;
        scrambledNum += 33;
      }
      _password += String.fromCharCode(scrambledNum);
      if(i % 2 == special){_password += String.fromCharCode((i%6) + 33);}
      if(i % 3 == numbers){_password += String.fromCharCode((i%10) + 48);}
    }
    // Check psudo constraints are met.
    _checkPsudo();
    return;
  }

  /// Returns a password based on the generators settings.
  /// If in random mode, any string input will be discarded.
  /// Exceptions: 
  /// 
  ///   [GeneratorNullError] on [_userPhrase] null and [_isPsudo] true.
  /// 
  ///   [UnsupportedError] on no cryptographically secure source of random numbers.
  String generatePassword(String? scramble){
    if (_userPhrase == null && _isPsudo){
      throw const GeneratorNullError();
    }

    _isPsudo ? _psudoPassword(scramble ?? r" ") : _randomPassword();

    return _password;
  }
}