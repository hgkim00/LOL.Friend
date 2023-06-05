import 'package:flutter/material.dart';
import 'package:lol_friend/views/map/maps.dart';
import 'package:lol_friend/views/community/community.dart';
import 'package:lol_friend/views/home/home.dart';
import 'package:lol_friend/views/rank.dart';
import 'package:lol_friend/views/setting.dart';

class NavigationService extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Widget getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const CommunityPage();
      case 2:
        return MapsPage();
      case 3:
        return const RankPage();
      case 4:
        return const SettingPage();
      default:
        return const HomePage();
    }
  }
}
