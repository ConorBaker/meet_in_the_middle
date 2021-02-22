import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'loading.dart';

class CreateFamily extends StatefulWidget {
  @override
  _CreateFamilyState createState() => _CreateFamilyState();
}

class _CreateFamilyState extends State<CreateFamily> {
    final _formKey = GlobalKey<FormState>();
    final _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


    @override
    Widget build(BuildContext context) {
      final user = Provider.of<User>(context);
      String code = getRandomString(5);
      return StreamBuilder<UserData>(
          stream: DataBaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                            "Welcome To Meet In The Middle! Below is your family code, Your family members can add this code to their account to join your family.",
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(code, style: TextStyle(
                            fontSize: 50.0,
                          )),
                        )
                      ],

                    ),
                    RaisedButton(
                      child: Text(
                          'Ok'
                      ),
                      onPressed: () async {
                        await DataBaseService(uid: user.uid)
                            .updateUserData(
                            userData.uid,
                            userData.name,
                            userData.lat,
                            userData.lng,
                            code,
                            "",
                            userData.profileImage
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Loading();
            }
          }
      );
    }
  }
