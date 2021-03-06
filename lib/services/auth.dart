import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/services/database.dart';
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create user object based on firebaseUSer
  User _userFromFireBaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFireBaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      await DataBaseService(uid: user.uid).updateUserData(user.uid.toString(),'New Family Member',0,0,"","","assets/Man1.png",0,false,"");

      return _userFromFireBaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in w email password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try {
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}