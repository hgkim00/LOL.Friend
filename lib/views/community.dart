import 'package:flutter/material.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
        body: Column(
          children: const [
            Text("This is Community Page"),
          ],
        ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
