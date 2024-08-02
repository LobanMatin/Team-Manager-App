import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:team_manager_application/models/training_model.dart';
import 'package:team_manager_application/services/auth_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


// Class to display all of the application information
class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {

  // Create a reference to the realtime database to read and write data
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  // Get user id of logged in user
  String uid = FirebaseAuth.instance.currentUser!.uid;


  // Create variables to store database information
  List<TrainingInstance> trainingList = [];
  List<String> terminology = [];
  List<Padding> videoList = [];
  Map<dynamic, dynamic> poomsae = {};
  String randomTip = "";
  String beltLevel = "";

  // Create a map of controllers for poomsae videos
  late final Map<dynamic, YoutubePlayerController> _controllerList = {};

  @override
  void initState() {
    super.initState();

    // Retrieve database information on page start up
    retrieveTrainingData();
    retrieveResourceData();
  }

  @override
  Widget build(BuildContext context) {

    // Content page body
    return Scaffold(

      // Page background colour
      backgroundColor: Theme.of(context).colorScheme.tertiary,

      // Page app bar
      appBar: AppBar(
        title: const Text("MUTKD APP"),
        backgroundColor: Colors.transparent,

        // Add menu anchor button to add sign out functionality
        actions: <Widget>[
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(

                // When anchor pressed, open dropdown
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

            // Sign out option for menu anchor dropdown
            menuChildren: <MenuItemButton>[
              MenuItemButton(
                onPressed: () {

                  // Prompt user to confirm whether they want to sign out
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Sign Out"),
                        content:
                            const Text("Are you sure you want to sign out?"),
                        actions: [

                          // Clost alert dialog when cancelled
                          TextButton(
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                          // Sign user out when sign out confirmed
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

                // Anchor dropdown label
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),

      // Content page main body
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.transparent,

                  // Scrollable widget to display all information
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

                        // Display a list of trainingWidgets in series for each session for the week
                        for (int i = 0; i < trainingList.length; i++)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                            child: trainingWidget(trainingList[i]),
                          ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                        ),

                        // Tips and Resources section
                        Text(
                          "Tips & Resources",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        ),

                        // Korean Terminology sub section
                        Text(
                          "Korean Terminology",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        ),

                        //For each instance of terminology create a new Text widget at a new line
                        for (int i = 0; i < terminology.length; i++)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                            child: Text(terminology[i].toString()),
                          ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                        ),

                        // Poomsae resources sub section
                        Text(
                          "Poomsae Resources",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        // Create a video carousel to display all poomsae videos
                        CarouselSlider(
                          items: videoList,
                          options: CarouselOptions(
                            height: MediaQuery.sizeOf(context).height * 0.35,
                            enlargeCenterPage: true,
                          ),
                        ),

                        // Random helpful tip sub section
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

  // Function to read training data from the realtime database
  Future<void> retrieveTrainingData() async {

    // Read training data from database as a Map
    final data = (await dbRef.child("trainings").get()).value as Map;

    // Create TrainingInstances using the read data for each session
    for (var session in data.keys) {
      final datapoint = TrainingData.fromJson((data[session]));
      TrainingInstance training =
          TrainingInstance(key: session, trainingData: datapoint);

      // add the TrainingInstances to trainingList to display on the content page
      trainingList.add(training);
      setState(() {});
    }
  }

  // Custom widget to display all training information for each session
  Widget trainingWidget(TrainingInstance trainingList) {
    return Container(

      // Match the width of the display
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

                // Display the training date and time
                Text(
                  trainingList.trainingData!.datetime!,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),

                // Display the training location
                Text(
                  trainingList.trainingData!.location!,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),

                // Display the training description
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


  // Function to read resources data from the realtime database
  Future<void> retrieveResourceData() async {

    // Read user belt data to determine which resources to display
    beltLevel = (await dbRef.child("users/$uid/belt").get()).value as String;

    // Read the appropriate resource data as a Map
    final resourceData =
        (await dbRef.child("resources/$beltLevel").get()).value as Map;

    // Read the helpful tips from database as Map
    final tipsData = (await dbRef.child("tips").get()).value as Map;


    // Seperate korean terminology from data
    terminology = [
      for (var tech in resourceData["korean"].keys) resourceData["korean"][tech]
    ];

    // Seperate poomsae resoureces from data
    poomsae =
        (await dbRef.child("resources/$beltLevel/poomsae").get()).value as Map;

    // Create a Youtube video player for each of the poomsae videos
    for (var title in poomsae.keys) {

      // Create a cotroller for each of the available videos
      _controllerList[title.toString()] = YoutubePlayerController(
        initialVideoId: poomsae[title],
        flags: const YoutubePlayerFlags(

          // Do not auto play, or show full screen button
          autoPlay: false,
          disableDragSeek: true,
          showLiveFullscreenButton: false,
        ),
      );

      // Add each of the video players to videoList to display on the content page
      videoList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
          child: Column(
            children: [

              // Create a player from video controller initialised previously
              YoutubePlayer(
                controller: _controllerList[title.toString()]!,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                ],
              ),

              // Add the title of the poomsae to the player
              Text(
                title.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    // Select a random tip from those available to display
    var randInt = Random().nextInt(tipsData.length - 1);
    randomTip = tipsData['t$randInt'].toString();

    setState(() {});
  }
}
