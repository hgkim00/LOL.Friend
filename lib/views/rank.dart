import 'package:flutter/material.dart';
import 'package:lol_friend/services/auth_service.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/appbar.png'),
          actions: [
            IconButton(
              onPressed: () {
                auth.logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: const [
            Text("This is Rank Page"),
          ],
        ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
