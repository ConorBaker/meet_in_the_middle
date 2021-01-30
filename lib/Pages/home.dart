import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/Pages/user_list.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/category_selector.dart';
import 'package:meet_in_the_middle/shared/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}

class Home_State extends State<Home> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;
  UserData currentUser;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void _showSettingsPanel() {
      Navigator.pop(context);
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc){
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  child : SettingsForm(),
              ),
            );
          }
      );
    }

    void _createFamily() {
      Navigator.pop(context);
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc){
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child : SettingsForm(),
              ),
            );
          }
      );
    }

    void _joinFamily() {
      Navigator.pop(context);
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc){
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child : SettingsForm(),
              ),
            );
          }
      );
    }

    return StreamBuilder<UserData>(
        stream: DataBaseService(uid: user.uid).userData,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        currentUser = snapshot.data;
        return StreamProvider<List<UserData>>.value(
          value: DataBaseService().users,
          child: Scaffold(
            backgroundColor: Color.fromRGBO(163, 217, 229, 1),
            appBar: AppBar(
              title: Text('Meet In The Middle',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              backgroundColor: Color.fromRGBO(163, 217, 229, 1),
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  textColor: Colors.white,
                  icon: Icon(Icons.person),
                  label: Text('Logout'),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                ),
              ],
            ),
            drawer: Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(163, 217, 229, 1),
                      ),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage: AssetImage(currentUser.profileImage),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            currentUser.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    ListTile(
                      title: Text('Update Profile'),
                      leading: Icon(Icons.settings),
                      onTap: () {
                        _showSettingsPanel();
                      },
                    ),
                    ListTile(
                      title: Text('Create a Family'),
                      leading: Icon(Icons.add),
                      onTap: () {
                        _createFamily();
                      },
                    ),
                    ListTile(
                      title: Text('Join a Family'),
                      leading: Icon(Icons.workspaces_filled),
                      onTap: () {
                        _joinFamily();
                      },
                    ),
                  ],
                )),
            body: Column(
              children: <Widget>[
                CategorySelector(),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(242, 243, 245, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: UserList()),
                ),
              ],
            ),
          ),
        );
      }else{
        return Loading();
      }
    }
    );
  }
}
