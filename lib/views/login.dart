import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/title.png',
                height: height * 0.28,
                fit: BoxFit.cover,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("구글로 로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
