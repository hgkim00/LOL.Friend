import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend/services/setting_service.dart';

class ReportBug extends StatelessWidget {
  const ReportBug({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final settingService = SettingService();

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
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(30, 100, 30, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "불편하신 점이 있으신가요?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  '이용 중 불편한 점이나 문의 사항을 알려주세요!',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  '확인 후 신속 정확하게 답변 드리도록 하겠습니다 :)',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  '평일 (월-금) 09:00 ~ 18:00, 주말 및 공휴일 휴무',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  width: width * 0.5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: const BorderSide(width: 0.5),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () {
                      settingService.sendEmail(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "이메일 보내기",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 3),
                        Icon(CupertinoIcons.chevron_forward),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
