import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend/services/navigation_service.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationService>(context);

    return NavigationBar(
      onDestinationSelected: (int index) {
        navigationService.setIndex(index);
      },
      selectedIndex: navigationService.selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.house_fill),
          icon: Icon(CupertinoIcons.house),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.person_2_fill),
          icon: Icon(CupertinoIcons.person_2),
          label: 'Community',
        ),
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.chat_bubble_fill),
          icon: Icon(CupertinoIcons.chat_bubble),
          label: 'Chat',
        ),
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.chart_bar_fill),
          icon: Icon(CupertinoIcons.chart_bar),
          label: 'Rank',
        ),
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.gear_alt_fill),
          icon: Icon(CupertinoIcons.gear_alt),
          label: 'Setting',
        ),
      ],
    );
  }
}
