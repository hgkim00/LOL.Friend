import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Color outlineColor = Theme.of(context).colorScheme.outline;
    String? riotApi = dotenv.env['RIOT_API'];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'assets/images/appbar.png',
              height: 40,
              fit: BoxFit.fitHeight,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.search),
                    prefixIconColor: outlineColor,
                    hintText: '소환사 검색',
                    filled: true,
                    fillColor: const Color(0xFF1B2023),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    // focusedBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(width: 2, color: outlineColor)),
                    // border: const OutlineInputBorder(
                    //     borderSide: BorderSide(width: 1)),
                  ),
                  onFieldSubmitted: (value) {
                    Navigator.pushNamed(context, '/search', arguments: value);
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'My Information',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavigation(),
        ),
      ),
    );
  }
}
