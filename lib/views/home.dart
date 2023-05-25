import 'package:flutter/material.dart';
import 'package:lol_friend/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          children: const [],
        ),
      ),
    );
  }
}
