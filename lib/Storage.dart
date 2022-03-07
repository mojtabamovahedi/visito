import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{
  final _storage = FlutterSecureStorage();

  Future writeSecureStorage(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }


  Future readSecureStorage(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  Future deleteSecureStorage(String key, String value) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }
}