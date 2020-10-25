import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_in_the_middle/models/user.dart';
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
  //sign in w email password

  //register

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