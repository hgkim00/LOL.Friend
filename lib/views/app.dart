import 'package:flutter/material.dart';
import 'package:lol_friend/color_schemes.g.dart';
import 'package:lol_friend/views/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOL.Friend',
      routes: _routes,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

final _routes = <String, WidgetBuilder>{
  '/login': ((BuildContext context) => const LoginPage()),
};
