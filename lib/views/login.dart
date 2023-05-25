import 'package:flutter/material.dart';
import 'package:lol_friend/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/title.png',
                  height: height * 0.28,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: height * 0.3),
                const Text('친구들과 경쟁하세요'),
                const Text('LOL KING이 되어보세요'),
                SizedBox(height: height * 0.1),
                ElevatedButton(
                  onPressed: () {
                    auth.signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/glogo.png'),
                      const Text(
                        'Google 로그인',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Opacity(
                        opacity: 0,
                        child: Image.asset('assets/images/glogo.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
