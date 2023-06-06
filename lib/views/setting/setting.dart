import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend/services/auth_service.dart';
import 'package:lol_friend/services/navigation_service.dart';
import 'package:lol_friend/services/riot_service.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final nav = Provider.of<NavigationService>(context);
    final riotService = Provider.of<RiotService>(context);

    DateTime recentLOL =
        DateTime.fromMillisecondsSinceEpoch(riotService.lolUser.revisionDate);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("LOL SETTING"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${riotService.lolUser.name}님 반갑습니다',
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFFEBC248),
                ),
              ),
              const SizedBox(height: 10),
              const Text('최근 LOL 접속일'),
              Text(
                  '${recentLOL.year}년 ${recentLOL.month}월 ${recentLOL.day}일 ${recentLOL.hour}시 ${recentLOL.minute}분'),
              const SizedBox(height: 30),
              const Divider(height: 10),
              const SizedBox(height: 30),
              Card(
                child: ListTile(
                  leading: const SizedBox(
                    width: 20,
                    height: 20,
                    child: Icon(
                      CupertinoIcons.question_circle,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    '고객센터',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/report');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const SizedBox(
                    width: 23,
                    height: 23,
                    child: Icon(
                      CupertinoIcons.power,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    auth.logout();
                    nav.setIndex(0);
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
