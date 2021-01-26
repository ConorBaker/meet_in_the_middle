import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/constants.dart';
import 'package:meet_in_the_middle/shared/loading.dart';
import 'package:provider/provider.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  String _currentName;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    var _controller = TextEditingController();

    return StreamBuilder<UserData>(
      stream: DataBaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Update User Data',
                    style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 10.0),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please Enter a Name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                  ),
                SizedBox(height: 10.0),
                RaisedButton(
                  child: Text(
                      'Update'
                  ),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      await DataBaseService(uid: user.uid).updateUserData(
                          _currentName ?? userData.name, userData.lat, userData.lng
                      );
                      Navigator.pop(context);
                    }
                  },
                ),

              ],
            ),

          );
        } else{
          return Loading();
        }
      }
    );
  }
}
