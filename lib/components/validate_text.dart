import 'dart:core';
import 'package:email_validator/email_validator.dart';

class ValidateText {

  static String? email(String? value){
    if(value != null){
      final bool isValid = EmailValidator.validate(value);
      if(!isValid){
        return '正しいメールアドレスを入力してください';
      } else {
        return null;
      }
    } else{
      return "null error";
    }
  }
}