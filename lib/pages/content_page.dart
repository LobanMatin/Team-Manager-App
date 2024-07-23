import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:team_manager_application/models/training_model.dart';
import 'package:team_manager_application/services/auth_service.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {

  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  List<TrainingInstance> trainingList = [];

  @override
  void initState() {
    super.initState();

    retrieveTrainingData();
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
                  color: Colors.red,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      for (int i = 0; i < trainingList.length; i++)
                        trainingWidget(trainingList[i])
                    ],)
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> retrieveTrainingData() async {
    final data2 = await dbRef.child("Trainings").get() as Map;
    for (var session in data2.keys) {
      final datapoint = data2[data2[session]];
      TrainingInstance training = TrainingInstance(key: session, trainingData: datapoint);
      trainingList.add(training);
      setState(() {});
    }
  }
  
  Widget trainingWidget(TrainingInstance trainingList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children: [
            Text(trainingList.trainingData!.datetime!),
            Text(trainingList.trainingData!.location!),
            Text(trainingList.trainingData!.description!),
          ],)
      ],),
    );
  }
}
