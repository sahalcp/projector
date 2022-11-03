import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  /// Store a string value to the cache for a key
  Future<void> storeStringToCache({String key, String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Store an integer value to cache for a key
  Future<void> storeIntToCache({String key, int value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  /// Read a string value from cache
  Future<String> readStringFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Read an integer value from cache
  Future<int> readIntFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  /// Read an integer value from cache
  Future<bool> removeFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
