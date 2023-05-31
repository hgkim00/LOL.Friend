import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> getSummonerInfo(String? riotApi, String summonerName) async {
  String url =
      "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/$summonerName?api_key=$riotApi";
  http.Response response = await http.get(Uri.parse(url));
  Map<String, dynamic> summonerData = jsonDecode(response.body);
  print(summonerData);
  return summonerData.toString();
}
