import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lol_friend/models/lol_user.dart';

class RiotService extends ChangeNotifier {
  LolUser lolUser = LolUser(
      id: '',
      accountId: '',
      puuid: '',
      name: '',
      profileIconId: -1,
      revisionDate: -1,
      summonerLevel: -1,
      tier: '',
      rank: '',
      leaguePoints: -1,
      wins: -1,
      losses: -1);
  String? riotApi = dotenv.env['RIOT_API'];
  List<String> mostChamps = [];
  List<String> rotationChamps = [];
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<bool> isNickRegister() async {
    String? nick;
    await _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      nick = data['nick'];
    });

    if (nick != "") {
      return true;
    } else {
      return false;
    }
  }

  void updateUserNick(String nickName) {
    _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .update({'nick': nickName});

    notifyListeners();
  }

  Future<void> getSummonerInfo() async {
    String summonerName = '';
    await _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      summonerName = data['nick'];
    });
    // print(summonerName);
    String dataUrl =
        "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/$summonerName?api_key=$riotApi";
    http.Response dataResponse = await http.get(Uri.parse(dataUrl));
    Map<String, dynamic> summonerData = jsonDecode(dataResponse.body);
    if (summonerData['name'] != null) {
      lolUser.id = summonerData['id'];
      lolUser.accountId = summonerData['accountId'];
      lolUser.puuid = summonerData['puuid'];
      lolUser.name = summonerData['name'];
      lolUser.profileIconId = summonerData['profileIconId'];
      lolUser.revisionDate = summonerData['revisionDate'];
      lolUser.summonerLevel = summonerData['summonerLevel'];
    }

    String leagueUrl =
        "https://kr.api.riotgames.com/lol/league/v4/entries/by-summoner/${lolUser.id}?api_key=$riotApi";
    http.Response leagueResponse = await http.get(Uri.parse(leagueUrl));
    List<dynamic> summonerLeague = jsonDecode(leagueResponse.body);

    // print(summonerLeague[0]['tier']);
    if (summonerLeague[0]['leagueId'] != null) {
      lolUser.tier = summonerLeague[0]['tier'];
      lolUser.rank = summonerLeague[0]['rank'];
      lolUser.leaguePoints = summonerLeague[0]['leaguePoints'];
      lolUser.wins = summonerLeague[0]['wins'];
      lolUser.losses = summonerLeague[0]['losses'];
    }
  }

  Future<void> getMostChamp() async {
    mostChamps = [];

    String dataUrl =
        "https://kr.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/${lolUser.id}?api_key=$riotApi";
    http.Response response = await http.get(Uri.parse(dataUrl));
    List<dynamic> data = jsonDecode(response.body);
    List<int> mostChampId = [];
    for (int i = 0; i < 3; i++) {
      mostChampId.add(data[i]['championId']);
    }

    String champUrl =
        "http://ddragon.leagueoflegends.com/cdn/13.11.1/data/ko_KR/champion.json";
    http.Response champResponse = await http.get(Uri.parse(champUrl));
    Map<String, dynamic> champData = jsonDecode(champResponse.body);
    Map<String, dynamic> cdata = champData['data'];

    cdata.forEach((key, value) {
      for (int i = 0; i < 3; i++) {
        if (cdata[key]['key'] == mostChampId[i].toString()) {
          mostChamps.add(cdata[key]['id']);
        }
      }
    });
  }

  Future<void> getRotationChamp() async {
    rotationChamps = [];
    String url =
        "https://kr.api.riotgames.com/lol/platform/v3/champion-rotations?api_key=$riotApi";
    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> rotation = data['freeChampionIds'];
    List<int> rotationChampId = [];
    for (int i = 0; i < rotation.length; i++) {
      rotationChampId.add(data['freeChampionIds'][i]);
    }

    String champUrl =
        "http://ddragon.leagueoflegends.com/cdn/13.11.1/data/ko_KR/champion.json";
    http.Response champResponse = await http.get(Uri.parse(champUrl));
    Map<String, dynamic> champData = jsonDecode(champResponse.body);
    Map<String, dynamic> champions = champData['data'];
    champions.forEach((key, value) {
      for (int i = 0; i < rotation.length; i++) {
        if (champions[key]['key'] == rotationChampId[i].toString()) {
          rotationChamps.add(champions[key]['id']);
        }
      }
    });
  }
}
