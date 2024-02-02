import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _userIdKey = 'userId';

class StorageService {
  StorageService._privateConstructor();

  static final StorageService _instance = StorageService._privateConstructor();

  factory StorageService() {
    return _instance;
  }

  final _secureStorage = const FlutterSecureStorage();

  // Future<String?> getAccessToken() async {
  //   return await _readSecureData(_accessTokenKey);
  // }
  //
  // Future<void> setAccessToken(String value) async {
  //   await _writeSecureData(_accessTokenKey, value);
  // }
  //
  // Future<String?> getRefreshToken() async {
  //   return await _readSecureData(_refreshTokenKey);
  // }
  //
  // Future<void> setRefreshToken(String value) async {
  //   await _writeSecureData(_refreshTokenKey, value);
  // }

  Future<String?> getUserId() async {
    return await _readSecureData(_userIdKey);
  }

  Future<void> setUserId(String value) async {
    await _writeSecureData(_userIdKey, value);
  }

  // Future<String?> getGAUserId() async {
  //   return await _readSecureData(_gaUserIdKey);
  // }
  //
  // Future<void> setGAUserId(String value) async {
  //   await _writeSecureData(_gaUserIdKey, value);
  // }
  //
  // Future<String?> getGAGuestId() async {
  //   return await _readSecureData(_gaGuestIdKey);
  // }
  //
  // Future<void> setGAGuestId(String value) async {
  //   await _writeSecureData(_gaGuestIdKey, value);
  // }
  //
  // Future<String?> getTokenExpiredAtKey() async {
  //   return await _getString(_tokenExpiredAtKey);
  // }
  //
  // Future<void> setTokenExpiredAtKey(String value) async {
  //   await _setString(_tokenExpiredAtKey, value);
  // }
  //
  // Future<void> setRefreshTokenUpdatedAt(String value) async {
  //   await _setString(_refreshTokenUpdatedAt, value);
  // }
  //
  // Future<void> setDistrictId(String value) async {
  //   await _setString(_districtId, value);
  // }
  //
  // Future<String?> getDistrictId() async {
  //   return await _getString(_districtId);
  // }
  //
  // Future<String?> getRefreshTokenUpdatedAt() async {
  //   return await _getString(_refreshTokenUpdatedAt);
  // }

  // Future<String?> getRefreshTokenExpiredAt() async {
  //   return await _getString(_refreshTokenExpiredAtKey);
  // }

  // Future<void> setRefreshTokenExpiredAt(String value) async {
  //   await _setString(_refreshTokenExpiredAtKey, value);
  // }

  Future<void> clear() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _deleteAllSecureData();

    // 모든 키들을 순회합니다.
    // for (String key in prefs.getKeys()) {
    // 제외할 패턴을 포함하지 않는 키만 삭제합니다.
    // if (!shouldExclude(key)) {
    //   await prefs.remove(key);
    // }
    // }

    // await _setBool(_isFirstRunKey, false);
  }

  //.setting
  // preferences
  // Future<int?> _getInt(String key) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt(key);
  // }
  //
  // Future<String?> _getString(String key) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(key);
  // }
  //
  // Future<bool?> _getBool(String key) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool(key);
  // }
  //
  // Future<void> _setInt(String key, int value) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt(key, value);
  // }
  //
  // Future<void> _setString(String key, String value) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(key, value);
  // }
  //
  // Future<void> _setBool(String key, bool value) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool(key, value);
  // }
  //.preferences

  // secure
  Future<void> _deleteAllSecureData() async {
    // GuestId앱 설치 시 최초 1번만 생성 되고 유지되어야 함.
    // 예외 처리> 앱 실행 시 GuestId가 없다면 생성 됨.
    // 사용하지 않음. await _secureStorage.deleteAll(aOptions: _getAndroidOptions());

    final secureData =
        await _secureStorage.readAll(aOptions: _getAndroidOptions());
    secureData.forEach((key, value) async {
      // if (_kExcludeSecureKeys.contains(key) == false) {
      await _secureStorage.delete(key: key);
      // }
    });
  }

  // Future<void> _deleteSecureData(String key) async {
  //   await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  // }

  Future<String?> _readSecureData(String key) async {
    var readData =
        await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: false,
      );

  Future<void> _writeSecureData(String key, String value) async {
    await _secureStorage
        .write(
          key: key,
          value: value,
          aOptions: _getAndroidOptions(),
        )
        .then((value) => print('successful writing.'));
  }
//.secure
}
