// Training object with relevant trainiing data acquired from realtime database
class TrainingInstance {
  String? key;
  TrainingData? trainingData;

  TrainingInstance({this.key, this.trainingData});
}

// Data of a training instance, include the date, time, location and description of session
class TrainingData {
  String? datetime;
  String? description;
  String? location;

  TrainingData({this.datetime, this.description, this.location,});

  // Acquire data from json format, as provided by the realtime database
  TrainingData.fromJson(Map<dynamic, dynamic> json) {
    datetime = json["datetime"];
    description = json["description"];
    location = json["location"];
  }
}