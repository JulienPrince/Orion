import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home_screen.dart';
import '../screens/setup_screen.dart';
import '../services/app_preferences.dart';
import 'theme.dart';

class HermesApp extends StatelessWidget {
  const HermesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hermes',
      debugShowCheckedModeBanner: false,
      theme: hermesTheme,
      home: FutureBuilder<String?>(
        future: AppPreferences.getUrl(),
        builder: (context, snapshot) {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF141425),
            systemNavigationBarColor: Color(0xFF141425),
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ));
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              backgroundColor: Color(0xFF141425),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final url = snapshot.data;
          if (url == null || url.isEmpty) {
            return const SetupScreen();
          }
          return HomeScreen(webUrl: url);
        },
      ),
    );
  }
}
