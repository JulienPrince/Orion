import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';

bool get _isDesktop =>
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.linux;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_isDesktop) {
    await windowManager.ensureInitialized();

    final prefs = await SharedPreferences.getInstance();
    final width = prefs.getDouble('window_width') ?? 1280;
    final height = prefs.getDouble('window_height') ?? 800;
    final x = prefs.getDouble('window_x');
    final y = prefs.getDouble('window_y');

    final options = WindowOptions(
      size: Size(width, height),
      center: (x == null || y == null),
      title: 'Hermes',
      titleBarStyle: TitleBarStyle.normal,
      minimumSize: const Size(800, 600),
    );

    await windowManager.waitUntilReadyToShow(options, () async {
      if (x != null && y != null) {
        await windowManager.setPosition(Offset(x, y));
      }
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const HermesApp());
}
