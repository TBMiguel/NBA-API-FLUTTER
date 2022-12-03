import 'package:nba_api/models/team.dart';

class Game {
  final Team homeTeam;
  final Team visitorTeam;
  final String status;
  final DateTime date;
  final int homeTeamScore;
  final int visitorTeamScore;

  Game({
    required this.homeTeam,
    required this.visitorTeam,
    required this.status,
    required this.date,
    required this.homeTeamScore,
    required this.visitorTeamScore,
  });
}
