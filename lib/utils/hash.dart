import 'dart:convert';

import 'package:crypto/crypto.dart';

String hash(String word) {
  final bytes = utf8.encode(word);
  final digest = md5.convert(bytes);
  String hashedWord = digest.toString();
  return hashedWord;
}
