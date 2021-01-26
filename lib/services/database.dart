import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';



class DataBaseService {

  final String uid;
  DataBaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future updateUserData(String name, double lat, double lng) async {
    return await userCollection.document(uid).setData({
      'name' : name,
      'lat' : lat,
      'lng' : lng
    });
  }

  //UserData from snapshot
  UserData _userDataFromSnapShot(DocumentSnapshot snapshot){
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        lat: snapshot.data['lat'],
        lng: snapshot.data['lng']
    );
  }

  List<Users> _familyListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Users(
          name: doc.data['name'] ?? '',
          lat: doc.data['lat'] ?? '',
          lng: doc.data['lng'] ?? ''
      );
    }).toList();
  }


  //get user stream
  Stream<List<Users>> get users{
    return userCollection.snapshots()
        .map(_familyListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots()
    .map(_userDataFromSnapShot);
  }

}