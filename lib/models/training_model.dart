class TrainingInstance {
  String? key;
  TrainingData? trainingData;

  TrainingInstance({this.key, this.trainingData});
}

class TrainingData {
  String? datetime;
  String? description;
  String? location;

  TrainingData({this.datetime, this.description, this.location,});

  TrainingData.fromJson(Map<dynamic, dynamic> json) {
    datetime = json["datetime"];
    description = json["description"];
    location = json["location"];
  }
}