import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'loading.dart';

class JoinFamily extends StatefulWidget {
  @override
  _JoinFamilyState createState() => _JoinFamilyState();
}

class _JoinFamilyState extends State<JoinFamily> {
  final _formKey = GlobalKey<FormState>();
  String code = "";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DataBaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      Text('Enter Your Family Code To Join a Family',
                          style: TextStyle(fontSize: 18.0)),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Family Code'),
                          validator: (val) => val.isEmpty ? 'Please Enter a Code' : null,
                          style: TextStyle(color: Colors.black),
                          onChanged: (val){
                            setState(() => code = val);
                          },),
                      ),
                      SizedBox(height: 10.0),
                      Column(
                        children: [
                          RaisedButton(
                            child: Text(
                                'Update'
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
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
                              }
                            },
                          ),
                        ],
                      ),
                    ]
                ));
          } else {
            return Loading();
          }
        }
    );
  }
}
