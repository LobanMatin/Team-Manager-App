import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {

    final trainings = _database.child('trainings/').onValue.listen(e) {
      final String description = e.snapshot.value;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            ],
          ),
        ),
      ),
    );
  }
}

class Training {
  DateTime? time;
  String? location;
  String? description;
}

