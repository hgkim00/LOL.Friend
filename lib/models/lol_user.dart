class LolUser {
  LolUser({
    required this.id,
    required this.accountId,
    required this.puuid,
    required this.name,
    required this.profileIconId,
    required this.revisionDate,
    required this.summonerLevel,
    required this.tier,
    required this.rank,
    required this.leaguePoints,
    required this.wins,
    required this.losses,
  });

  late String id;
  late String accountId;
  late String puuid;
  late String name;
  late int profileIconId;
  late int revisionDate;
  late int summonerLevel;
  late String tier;
  late String rank;
  late int leaguePoints;
  late int wins;
  late int losses;
}
