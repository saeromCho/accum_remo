import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> saveToken(String token) async {
  final storage = const FlutterSecureStorage();
  await storage.write(key: 'userToken', value: token);
}

Future<String?> getToken() async {
  final storage = const FlutterSecureStorage();
  return await storage.read(key: 'userToken');
}
