import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:team_manager_application/models/training_model.dart';
import 'package:team_manager_application/services/auth_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  List<TrainingInstance> trainingList = [];
  List<String> terminology = [];
  Map<dynamic, dynamic> poomsae = {};
  String randomTip = "";
  final beltLevel = 'black'; // make this user dependent

  late final Map<dynamic, YoutubePlayerController> _controllerList = {};

  @override
  void initState() {
    super.initState();

    retrieveTrainingData();
    retrieveResourceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: const Text("Team Managing Application"),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_horiz),
                tooltip: 'Show menu',
              );
            },
            menuChildren: <MenuItemButton>[
              MenuItemButton(
                onPressed: () => AuthService.signOut(context: context),
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 50, 80, 50),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                          child: Text(
                            "This Week's Training Sessions:",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        for (int i = 0; i < trainingList.length; i++)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                            child: trainingWidget(trainingList[i]),
                          ),
                          Text(
                                "Tips & Resources",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "Korean Terminology",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              for (int i = 0; i < terminology.length; i++)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 20, 8, 20),
                                  child: Text(terminology[i].toString()),
                                ),
                              Text(
                                "Poomsae Resources",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              for (var key in poomsae.keys)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 20, 8, 20),
                                  child: Column(
                                    children: [
                                      Text(key.toString()),
                                      YoutubePlayer(
                                        controller:
                                            _controllerList[key.toString()]!,
                                      ),
                                    ],
                                  ),
                                ),
                              Text(
                                "Helpful Tip",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                randomTip,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> retrieveTrainingData() async {
    final data = (await dbRef.child("trainings").get()).value as Map;
    for (var session in data.keys) {
      final datapoint = TrainingData.fromJson((data[session]));
      TrainingInstance training =
          TrainingInstance(key: session, trainingData: datapoint);
      trainingList.add(training);
      setState(() {});
    }
  }

  Widget trainingWidget(TrainingInstance trainingList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(trainingList.trainingData!.datetime!),
              Text(trainingList.trainingData!.location!),
              Text(trainingList.trainingData!.description!),
            ],
          )
        ],
      ),
    );
  }

  Future<void> retrieveResourceData() async {
    final resourceData =
        (await dbRef.child("resources/$beltLevel").get()).value as Map;
    final tipsData = (await dbRef.child("tips").get()).value as Map;

    terminology = [
      for (var tech in resourceData["korean"].keys) resourceData["korean"][tech]
    ];

    poomsae =
        (await dbRef.child("resources/$beltLevel/poomsae").get()).value as Map;

    for (var title in poomsae.keys) {
      _controllerList[title.toString()] = YoutubePlayerController(
        initialVideoId: poomsae[title],
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }

    var randInt = Random().nextInt(10);
    randomTip = tipsData['t$randInt'].toString();

    setState(() {});
  }
}
