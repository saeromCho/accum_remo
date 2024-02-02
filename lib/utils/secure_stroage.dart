import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> saveToken(String token) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'userToken', value: token);
}

Future<String?> getToken() async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: 'userToken');
}
