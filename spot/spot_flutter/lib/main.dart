import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'client.dart';
import 'screens/app_shell.dart';
import 'screens/sign_in_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const SpotApp());
}

class SpotApp extends StatelessWidget {
  const SpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spot',
      debugShowCheckedModeBanner: false,
      theme: buildSpotTheme(Brightness.light),
      darkTheme: buildSpotTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      // Dark status-bar icons on light screens (and vice versa), including
      // screens without an AppBar.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: child!,
      ),
      home: const SignInScreen(child: AppShell()),
    );
  }
}
