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
}
