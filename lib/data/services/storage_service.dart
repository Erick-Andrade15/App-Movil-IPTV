import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true, 
      );

  Future<void> writeSecureData(String key, String value) async {
    debugPrint("Writing new data having key $key");
    await _secureStorage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
        iOptions: IOSOptions.defaultOptions,
        webOptions: WebOptions.defaultOptions);
  }

  Future<String?> readSecureData(String key) async {
    debugPrint("Reading data having key $key");
    var readData = await _secureStorage.read(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: IOSOptions.defaultOptions,
        webOptions: WebOptions.defaultOptions);
    return readData;
  }

  Future<void> deleteSecureData(String key) async {
    debugPrint("Deleting data having key $key");
    await _secureStorage.delete(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: IOSOptions.defaultOptions,
        webOptions: WebOptions.defaultOptions);
  }

  Future<bool> containsKeyInSecureData(String key) async {
    debugPrint("Checking data for the key $key");
    var containsKey = await _secureStorage.containsKey(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: IOSOptions.defaultOptions,
        webOptions: WebOptions.defaultOptions);
    return containsKey;
  }
}
