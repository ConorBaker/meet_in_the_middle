import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/map.dart';
import 'package:meet_in_the_middle/main.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {

  final Users user;
  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[900],
              backgroundImage: AssetImage('assets/LogoNoBlack.jpg'),
            ),
            onTap: () async {
              final user1 = Provider.of<User>(context);
              await DataBaseService(uid: user1.uid).updateUserData(
                  "test",user.lat,user.lng, user.token
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen(user.lat,user.lng)),
              );
            },
            title: Text(user.name),
          ),
        )
    );
  }
}