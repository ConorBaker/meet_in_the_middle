import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {

  final String uid;
  DataBaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future updateUserData(String surname, int age) async {
    return await userCollection.document(uid).setData({
      'surname' : surname,
      'age' : age
    });
  }

  //get user stream
  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }
}