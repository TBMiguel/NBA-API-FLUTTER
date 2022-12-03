// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_api/models/game.dart';
import 'package:nba_api/models/team.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Team> teams = [];
  List<Game> games = [];

  // buscar times
  Future getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
          abbreviation: eachTeam['abbreviation'],
          city: eachTeam['city'],
          name: eachTeam['name']);
      teams.add(team);
    }

    print(teams.length);
  }

  // buscar jogos
  Future getGames() async {
    var data = DateTime.now().year;

    var response = await http.get(
        Uri.https('balldontlie.io', 'api/v1/games', {'seasons[]': '$data'}));
    var jsonData = jsonDecode(response.body);

    for (var eachGame in jsonData['data']) {
      final team = Game(
          homeTeam: Team(
            name: eachGame['home_team']['name'],
            abbreviation: eachGame['home_team']['abbreviation'],
            city: eachGame['home_team']['city'],
          ),
          visitorTeam: Team(
            name: eachGame['visitor_team']['name'],
            abbreviation: eachGame['visitor_team']['abbreviation'],
            city: eachGame['visitor_team']['city'],
          ),
          status: eachGame['status'],
          date: DateTime.parse(eachGame['date']),
          homeTeamScore: eachGame['home_team_score'],
          visitorTeamScore: eachGame['visitor_team_score']);
      games.add(team);
    }

    print(games.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              //Titulo times
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 4, 4),
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'TIMES NBA - TEMPORADA ATUAL',
                    style: TextStyle(
                      color: Color.fromARGB(255, 29, 66, 138),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              //Area dos times
              Container(
                margin: const EdgeInsets.fromLTRB(4, 100, 4, 4),
                height: 100,
                //color: Colors.blue,
                child: nbaTeam(),
              ),
              //Titulo jogos
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 200, 4, 4),
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'JOGOS - TEMPORADA ATUAL',
                    style: TextStyle(
                      color: Color.fromARGB(255, 29, 66, 138),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              //Area dos jogos
              Container(
                margin: const EdgeInsets.fromLTRB(4, 260, 4, 4),
                height: 550,
                child: nbaGames(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget nbaTeam() {
    return FutureBuilder(
      future: getTeams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: teams.length, //aqui vai quantos times tem
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(10),
                width: 200,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 66, 138), //cor do retangulo
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  title: Text(
                    '${teams[index].name}',
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  ),
                  subtitle: Text(
                    '${teams[index].city}',
                    style: TextStyle(
                      color: Colors.grey[200],
                    ),
                  ),
                  trailing: Text(
                    '${teams[index].abbreviation}',
                    style: TextStyle(
                      color: Colors.grey[200],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget nbaGames() {
    return FutureBuilder(
      future: getGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: games.length, //aqui vai quantos jogos tem
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 66, 138), //cor do retangulo
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  title: Text(
                    '${games[index].homeTeam.name.toUpperCase()}: ${games[index].homeTeamScore}',
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  ),
                  subtitle: Text(
                    '${games[index].visitorTeam.name.toUpperCase()}: ${games[index].visitorTeamScore}',
                    style: TextStyle(
                      color: Colors.grey[200],
                    ),
                  ),
                  trailing: Text(
                    'DATA: ${games[index].date.day} / ${games[index].date.month} / ${games[index].date.year}  -  ${games[index].status.toUpperCase()}',
                    style: TextStyle(
                      color: Colors.grey[200],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}