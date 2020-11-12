import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_in_the_middle/models/users.dart';

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

  List<Users> _familyListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Users(
          surname: doc.data['surname'] ?? '',
        age: doc.data['age'] ?? 0
      );
    }).toList();
  }

  //get user stream
  Stream<List<Users>> get users{
    return userCollection.snapshots()
        .map(_familyListFromSnapshot);
  }
}