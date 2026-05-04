import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _keyUrl = 'webui_url';

  static Future<String?> getUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUrl);
  }

  static Future<void> saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUrl, url);
  }

  static Future<void> clearUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUrl);
  }
}
