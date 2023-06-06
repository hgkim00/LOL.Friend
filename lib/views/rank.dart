import 'package:flutter/material.dart';
import 'package:lol_friend/services/riot_service.dart';
import 'package:lol_friend/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    final riotService = Provider.of<RiotService>(context);
    double height = MediaQuery.of(context).size.height;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    String winRates = (riotService.lolUser.wins /
            (riotService.lolUser.wins + riotService.lolUser.losses))
        .toStringAsFixed(3);

    List<PieChartSectionData> showingSections = [
      PieChartSectionData(
        color: Colors.redAccent,
        value: riotService.lolUser.losses.toDouble(),
        title: '${riotService.lolUser.losses}패',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          // color: AppColors.mainTextColor1,
          shadows: shadows,
        ),
      ),
      PieChartSectionData(
        color: Colors.blueAccent,
        value: riotService.lolUser.wins.toDouble(),
        title: '${riotService.lolUser.wins}승',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          // color: AppColors.mainTextColor1,
          shadows: shadows,
        ),
      ),
    ];

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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Most Used Champions",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              FutureBuilder(
                  future: riotService.getMostChamp(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      print(riotService.mostChamps[0]);
                      return Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            Image.network(
                              'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${riotService.mostChamps[i]}_0.jpg',
                              height: 210,
                              fit: BoxFit.fitHeight,
                            ),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text("Something Wrong happened.."));
                    }
                  }),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Rates",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: height * 0.2,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            sections: showingSections,
                            centerSpaceRadius: 20,
                            borderData: FlBorderData(
                              show: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      'Total Win Rates: $winRates',
                      style: const TextStyle(fontSize: 16),
                    )),
                  ],
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
