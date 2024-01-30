import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashUtil {
  static String generateSha256Hash(String password) {
    // Convert the password String to a byte array
    var bytes = utf8.encode(password);
    // Compute the SHA-256 hash of the password bytes
    var digest = sha256.convert(bytes);
    // Convert the SHA-256 digest to a hex string and return
    return digest.toString();
  }
}
