import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CurrentUser with ChangeNotifier {
  String name;
  String email;
  String profileurl;
  bool isAdmin;
  List<dynamic> subscribedTo;
  DocumentReference reference;

  CurrentUser({this.name, this.email, this.profileurl, this.isAdmin});

  void updateCurrentUserData(CurrentUser user, {bool isNotify: false}) {
    name = user.name;
    email = user.email;
    profileurl = user.profileurl;
    isAdmin = user.isAdmin;
    reference = user.reference;
    subscribedTo = user.subscribedTo;
    if (isNotify) notifyListeners();
    print('subscribedTo: ' + subscribedTo.toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileurl': profileurl,
      'isadmin': isAdmin,
      'subscribedTo': [],
    };
  }

  CurrentUser.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        email = map['email'],
        profileurl = map['profileurl'],
        isAdmin = map['isadmin'],
        subscribedTo = List.from(map['subscribedTo']);

  CurrentUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
