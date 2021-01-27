import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';



class DataBaseService {

  final String uid;

  DataBaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection(
      'users');

  Future updateUserData(String uId, String name, double lat, double lng,
      String token,String message) async {
    return await userCollection.document(uid).setData({
      'uId': uId ?? '',
      'name': name ?? '',
      'lat': lat ?? '',
      'lng': lng ?? '',
      'token': token ?? '',
      'message' : message ?? ''
    });
  }


  //UserData from snapshot
  UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data['uId'] ?? '',
      name: snapshot.data['name'] ?? '',
      lat: snapshot.data['lat'] ?? '',
      lng: snapshot.data['lng'] ?? '',
      token: snapshot.data['token'] ?? '',
      message: snapshot.data['message'] ?? '',

    );
  }

  List<UserData> _familyListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserData(
          uid: doc.data['uId'] ?? '',
          name: doc.data['name'] ?? '',
          lat: doc.data['lat'] ?? '',
          lng: doc.data['lng'] ?? '',
          token: doc.data['token'] ?? '',
          message: doc.data['message'] ?? ''
      );
    }).toList();
  }

  //get user stream
  Stream<List<UserData>> get users {
    return userCollection.snapshots()
        .map(_familyListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots()
        .map(_userDataFromSnapShot);
  }
}