import 'package:firebase_database/firebase_database.dart';

class Cafe {
  String key;
  String address;
  String name;
  int food;
  int asthetic;

//  String userId;

  Cafe(this.address, this.name);

  Cafe.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
       // userId = snapshot.value["userId"],
        name = snapshot.value["name"],
        address = snapshot.value["address"],
        food = snapshot.value["food"],
        asthetic = snapshot.value["asthetic"];


  toJson() {
    return {
      "food" : food,
      "subject": name,
      "address": address,
      "asthetic": asthetic,
    };
  }
}