<<<<<<< HEAD
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
=======
>>>>>>> 4ebeb33281a26d5fd094e83f8a54d2a38ab91922
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
<<<<<<< HEAD
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  List<TrainingInstance> trainingList = [];
  List<String> terminology = [];
  Map<dynamic, dynamic> poomsae = {};
  String randomTip = "";
  String beltLevel = ""; 

  late final Map<dynamic, YoutubePlayerController> _controllerList = {};

  @override
  void initState() {
    super.initState();

    retrieveTrainingData();
    retrieveResourceData();
  }
=======
  final _database = FirebaseDatabase.instance.ref();
>>>>>>> 4ebeb33281a26d5fd094e83f8a54d2a38ab91922

  @override
  Widget build(BuildContext context) {

    final trainings = _database.child('trainings/').onValue.listen(e) {
      final String description = e.snapshot.value;
    }

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
<<<<<<< HEAD
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
=======
          padding: const EdgeInsets.fromLTRB(80, 50, 80, 50),
>>>>>>> 4ebeb33281a26d5fd094e83f8a54d2a38ab91922
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
<<<<<<< HEAD
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
=======
                  color: Colors.red,
                  child: const Placeholder(),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.blue,
                          child: const Placeholder(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.yellow,
                          child: const Placeholder(),
                        ),
                      ),
                    ],
                  ),
              )
>>>>>>> 4ebeb33281a26d5fd094e83f8a54d2a38ab91922
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
    beltLevel = (await dbRef.child("users/$uid/belt").get()).value as String;
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

