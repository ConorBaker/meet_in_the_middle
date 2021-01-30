
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/constants.dart';
import 'package:meet_in_the_middle/shared/loading.dart';
import 'package:provider/provider.dart';


class CreateFamily extends StatefulWidget {
  @override
  _CreateFamily createState() => _CreateFamily();
}

class _CreateFamily extends State<CreateFamily> {
  int selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  String _currentName;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Location location = new Location();

    return StreamBuilder<UserData>(
        stream: DataBaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      Text('Family Code',
                          style: TextStyle(fontSize: 18.0)),
                      SizedBox(height: 10.0),
                      Text('Family Code',
                          style: TextStyle(fontSize: 18.0)),
                    ]
                ));
          } else {
            return Loading();
          }
        }
    );
  }
}
