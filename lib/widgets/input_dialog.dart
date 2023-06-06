import 'package:flutter/material.dart';
import 'package:lol_friend/services/riot_service.dart';
import 'package:provider/provider.dart';

class InputDialog extends StatelessWidget {
  InputDialog({super.key});

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final riotService = Provider.of<RiotService>(context);

    return AlertDialog(
      title: const Text('본인 롤 닉네임 입력', style: TextStyle(fontSize: 15)),
      content: TextField(
        style: const TextStyle(fontSize: 15),
        controller: _textEditingController,
        decoration: const InputDecoration(
          hintText: '닉네임을 입력하세요',
        ),
      ),
      actions: [
        ElevatedButton(
          child: const Text('확인'),
          onPressed: () {
            String inputText = _textEditingController.text;
            riotService.updateUserNick(inputText);
            Navigator.of(context).pop(inputText);
          },
        ),
        ElevatedButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
