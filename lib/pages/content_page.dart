import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Announcements',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SingleChildScrollView(
                    child: Column(children: [
                      Text('Hello')
                    ],),
                  )
                ],
              ),
              const Row(
                children: [
                  Column(
                    children: [
                      Text('Events'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Training Schedule'),
                      Row(
                        children: [
                          Text('Date and Time'),
                          VerticalDivider(),
                          Text('Location'),
                          VerticalDivider(),
                          Text('Description')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
