import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend/services/riot_service.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';
import 'package:lol_friend/widgets/input_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final riotService = Provider.of<RiotService>(context);

    Color outlineColor = Theme.of(context).colorScheme.outline;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                  ),
                  onFieldSubmitted: (value) {
                    Navigator.pushNamed(context, '/search', arguments: value);
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Information',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return InputDialog();
                            },
                          );
                        },
                        icon: const Icon(CupertinoIcons.pencil),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: riotService.getSummonerInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: height * 0.2,
                        width: width,
                        color: const Color(0xFF1B2023),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return GestureDetector(
                        onTap: riotService.lolUser.id != ''
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return InputDialog();
                                  },
                                );
                              },
                        child: Container(
                          height: height * 0.2,
                          width: width,
                          color: const Color(0xFF1B2023),
                          child: riotService.lolUser.id != ''
                              ? Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceAround,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        child: Image.network(
                                      'https://ddragon.leagueoflegends.com/cdn/13.11.1/img/profileicon/${riotService.lolUser.profileIconId}.png',
                                    )),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(riotService.lolUser.name,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                          Text(
                                              'LV. ${riotService.lolUser.summonerLevel}',
                                              style: const TextStyle(
                                                  fontSize: 16)),
                                          Image.asset(
                                            'assets/images/emblems/${riotService.lolUser.tier.toLowerCase()}.png',
                                            height: height * 0.08,
                                            fit: BoxFit.fitHeight,
                                          ),
                                          Text(
                                              '${riotService.lolUser.tier} ${riotService.lolUser.rank} ${riotService.lolUser.leaguePoints}'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                  ],
                                )
                              : const Center(
                                  child: Text("여기를 눌러서 자신의 닉네임 정보를 저장하세요!")),
                        ),
                      );
                    } else {
                      return Container(
                        height: height * 0.2,
                        width: width,
                        color: const Color(0xFF1B2023),
                        child: const Text('Something Wrong...'),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Weekly Rotation Champions',
                      style: TextStyle(fontSize: 18)),
                ),
                SizedBox(
                  height: height * 0.25,
                  child: FutureBuilder(
                      future: riotService.getRotationChamp(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0;
                                  i < riotService.rotationChamps.length;
                                  i++)
                                Column(
                                  children: [
                                    Image.network(
                                      'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${riotService.rotationChamps[i]}_0.jpg',
                                      height: height * 0.225,
                                    ),
                                    Text(riotService.rotationChamps[i]),
                                  ],
                                ),
                            ],
                          ),
                        );
                      }),
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
