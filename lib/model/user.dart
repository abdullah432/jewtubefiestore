import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CurrentUser with ChangeNotifier {
  String name;
  String email;
  String profileurl;
  bool isAdmin;
  DocumentReference reference;

  CurrentUser({this.name, this.email, this.profileurl, this.isAdmin});

  void updateCurrentUserData(CurrentUser user, {bool isNotify: false}) {
    name = user.name;
    email = user.email;
    profileurl = user.profileurl;
    isAdmin = user.isAdmin;
    reference = user.reference;
    if (isNotify) notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileurl': profileurl,
      'isadmin': isAdmin,
    };
  }

  CurrentUser.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        email = map['email'],
        profileurl = map['profileurl'],
        isAdmin = map['isadmin'];

  CurrentUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
