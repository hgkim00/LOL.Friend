import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend/color_schemes.g.dart';
import 'package:lol_friend/models/post.dart';
import 'package:lol_friend/services/navigation_service.dart';
import 'package:lol_friend/views/community/add_post.dart';
import 'package:lol_friend/views/community/detail.dart';
import 'package:lol_friend/views/community/edit_post.dart';
import 'package:lol_friend/views/login.dart';
import 'package:lol_friend/views/home/search.dart';
import 'package:lol_friend/views/setting/report_bug.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOL.Friend',
      routes: _routes,
      onGenerateRoute: (settings) {
        if (settings.name == '/search') {
          final String? data = settings.arguments as String?;
          return MaterialPageRoute(
              builder: (context) => SearchSummonerPage(data: data ?? "NULL"));
        }
        if (settings.name == '/detail') {
          final Post post = settings.arguments as Post;
          return MaterialPageRoute(
              builder: (context) => DetailPage(post: post));
        }
        if (settings.name == '/edit') {
          final Post post = settings.arguments as Post;
          return MaterialPageRoute(
              builder: (context) => EditPost(existPost: post));
        }
        return null;
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
        ),
        textTheme:
            ThemeData.dark().textTheme.apply(fontFamily: 'BeaufortforLOL'),
      ),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return Consumer<NavigationService>(
                  builder: (context, navigationService, _) {
                return navigationService
                    .getPageByIndex(navigationService.selectedIndex);
              });
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}

final _routes = <String, WidgetBuilder>{
  '/addpost': ((BuildContext context) => const AddPost()),
  '/report': ((BuildContext context) => const ReportBug()),
};
