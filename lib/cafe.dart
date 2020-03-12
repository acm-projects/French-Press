import 'package:firebase_database/firebase_database.dart';

class Cafe {
  String key;
  String address;
  String name;
//  String userId;

  Cafe(this.address, this.name);

  Cafe.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
       // userId = snapshot.value["userId"],
        name = snapshot.value["name"],
        address = snapshot.value["address"];

  toJson() {
    return {

      "subject": name,
      "address": address,
    };
  }
}