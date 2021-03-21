import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';

class DataBaseService {
  final String uid;

  DataBaseService({this.uid});

  final CollectionReference userCollection =
  Firestore.instance.collection('users');
  final CollectionReference locationCollections =
  Firestore.instance.collection('places');

  Future updateUserData(String uId, String name, double lat, double lng,
      String token, String message, String profileImage, int count,bool parent) async {
    return await userCollection.document(uid).setData({
      'uId': uId ?? '',
      'name': name ?? '',
      'lat': lat ?? '',
      'lng': lng ?? '',
      'token': token ?? '',
      'message': message ?? '',
      'profileImage': profileImage ?? '',
      'count': count ?? 0,
      'parent' : parent ?? false,
    });
  }

  Future updatePlaceData(String name, double lat, double lng,
      String day, String picture) async {
    return await locationCollections.document(uid).setData({
      'name': name ?? '',
      'lat': lat ?? '',
      'lng': lng ?? '',
      'day': day ?? '',
      'picture': picture ?? ''
    });
  }

  //UserData from snapshot
  UserData userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data['uId'] ?? '',
      name: snapshot.data['name'] ?? '',
      lat: snapshot.data['lat'] ?? '',
      lng: snapshot.data['lng'] ?? '',
      token: snapshot.data['token'] ?? '',
      message: snapshot.data['message'] ?? '',
      profileImage: snapshot.data['profileImage'] ?? '',
      count: snapshot.data['count'] ?? 0,
    );
  }

  List<UserData> familyListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserData(
          uid: doc.data['uId'] ?? '',
          name: doc.data['name'] ?? '',
          lat: doc.data['lat'] ?? '',
          lng: doc.data['lng'] ?? '',
          token: doc.data['token'] ?? '',
          message: doc.data['message'] ?? '',
          profileImage: doc.data['profileImage'] ?? '',
          count: doc.data['count'] ?? 0);
    }).toList();
  }

  List<Place> LocationListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Place(
        name: doc.data['name'] ?? '',
        lat: doc.data['lat'] ?? '',
        lng: doc.data['lng'] ?? '',
        day: doc.data['day'] ?? '',
        picture: doc.data['picture'] ?? '',
      );
    }).toList();
  }

  //get user stream
  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(familyListFromSnapshot);
  }

  //get location stream
  Stream<List<Place>> get places {
    return locationCollections.snapshots().map(LocationListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(userDataFromSnapShot);
  }
}
