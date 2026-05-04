import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class WindowPreferences {
  static Future<void> save() async {
    if (defaultTargetPlatform != TargetPlatform.macOS &&
        defaultTargetPlatform != TargetPlatform.windows) {
      return;
    }
    final bounds = await windowManager.getBounds();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('window_width', bounds.width);
    await prefs.setDouble('window_height', bounds.height);
    await prefs.setDouble('window_x', bounds.left);
    await prefs.setDouble('window_y', bounds.top);
  }
}
