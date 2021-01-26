import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_in_the_middle/Pages/users.tile.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<Users>>(context) ?? [];
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index){
        return UserTile(user: users[index]);
      }
    );
  }
}
