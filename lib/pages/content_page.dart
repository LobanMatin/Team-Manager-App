import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String uid = FirebaseAuth.instance.currentUser!.uid;

  List<TrainingInstance> trainingList = [];
  List<String> terminology = [];
  List<Padding> videoList = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: const Text("MUTKD APP"),
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Sign Out"),
                        content:
                            const Text("Are you sure you want to sign out?"),
                        actions: [
                          TextButton(
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text(
                              "Sign Out",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              AuthService.signOut(context: context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
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
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                        ),
                        Text(
                          "Tips & Resources",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        ),
                        Text(
                          "Korean Terminology",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        ),
                        for (int i = 0; i < terminology.length; i++)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                            child: Text(terminology[i].toString()),
                          ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                        ),
                        Text(
                          "Poomsae Resources",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        CarouselSlider(
                          items: videoList,
                          options: CarouselOptions(
                            height: MediaQuery.sizeOf(context).height * 0.35,
                            enlargeCenterPage: true,
                          ),
                        ),
                        Text(
                          "Helpful Tip",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
                          child: Text(
                          randomTip,
                          textAlign: TextAlign.center,
                        ),
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  trainingList.trainingData!.datetime!,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                Text(
                  trainingList.trainingData!.location!,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                Text(
                  trainingList.trainingData!.description!,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
          disableDragSeek: true,
          showLiveFullscreenButton: false,
        ),
      );

      videoList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
          child: Column(
            children: [
              YoutubePlayer(
                controller: _controllerList[title.toString()]!,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                ],
              ),
              Text(
                title.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    var randInt = Random().nextInt(8);
    randomTip = tipsData['t$randInt'].toString();

    setState(() {});
  }
}
