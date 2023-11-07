import 'dart:io';  
import 'package:path_provider/path_provider.dart'; 
import "package:logger/logger.dart";

var logger = Logger();

// 新しいファイルに文字列書き込む関数
Future<void> writeToFile(String text, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName.txt');
  await file.writeAsString(text);

  logger.d("ファイルが保存されました: ${file.path}");
}