import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/map.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';



class UserTile extends StatelessWidget {
  final UserData user;
  UserTile({this.user});



  sendNotifcation(String uID, String uID2) async{
    String chatID = 'A' + "_" + 'B';
    List<String> users = [uID,uID2];
    Map<String, dynamic> chatMap = {
      'users' : user,
      'chatID' : chatID,
    };
    await DataBaseService(uid : uID).updateChatRoom(chatID, chatMap);
  }


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
            onTap: () async{
              /*
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen(user.lat,user.lng)),
              );

               */
              final user1 = Provider.of<User>(context);
              sendNotifcation(user1.uid,user.uid);
            },
            title: Text(user.name),
          ),
        )
    );
  }
}