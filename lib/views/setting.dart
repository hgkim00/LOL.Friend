import 'package:flutter/material.dart';
import 'package:lol_friend/services/auth_service.dart';
import 'package:lol_friend/services/navigation_service.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final nav = Provider.of<NavigationService>(context);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/appbar.png',
            height: 40,
            fit: BoxFit.fitHeight,
          ),
          actions: [
            IconButton(
              onPressed: () {
                auth.logout();
                nav.setIndex(0);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: const [
            Text("This is Setting Page"),
          ],
        ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
