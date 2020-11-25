import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/users.dart';

class UserTile extends StatelessWidget {

  final Users user;
  UserTile({this.user});
  @override
  Widget build(BuildContext context) {
    print('Under This');
    print(user.surname);
    print(user.age);
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
            title: Text(user.surname),
            subtitle: Text('Aged ${user.age}'),
          ),
        )
    );
  }
}