import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend/color_schemes.g.dart';
import 'package:lol_friend/services/navigation_service.dart';
import 'package:lol_friend/views/chat.dart';
import 'package:lol_friend/views/home.dart';
import 'package:lol_friend/views/community.dart';
import 'package:lol_friend/views/login.dart';
import 'package:lol_friend/views/rank.dart';
import 'package:lol_friend/views/setting.dart';
import 'package:provider/provider.dart';

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
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return Consumer<NavigationService>(
                  builder: (context, navigationService, _) {
                return getPageByIndex(navigationService.selectedIndex);
              });
            } else {
              return const LoginPage();
            }
          }),
    );
  }

  Widget getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const CommunityPage();
      case 2:
        return const ChatPage();
      case 3:
        return const RankPage();
      case 4:
        return const SettingPage();
      default:
        return const HomePage();
    }
  }
}

final _routes = <String, WidgetBuilder>{
  '/login': ((BuildContext context) => const LoginPage()),
};
