
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/constants.dart';
import 'package:meet_in_the_middle/shared/loading.dart';
import 'package:meet_in_the_middle/shared/picture_selector.dart';
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
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    final List<String> pictures = ['assets/Man1.png','assets/Man2.png', 'assets/Man3.png','assets/Woman1.png','assets/Woman2.png', 'assets/Woman3.png'];
    int selection = 0;


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
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(children: [
                    Text('Profile Picture'),
                  ]),
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                      padding: EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: pictures.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          onTap: () async{
                            await DataBaseService(uid: user.uid).updateUserData(
                                userData.uid, _currentName ?? userData.name, userData.lat, userData.lng, userData.token,"",pictures[index]
                            );
                            setState(()  {
                              selection = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 35.0,
                              backgroundImage: AssetImage(pictures[index]),
                            ),
                          ),
                        );
                      }),
                ),
                RaisedButton(
                  child: Text(
                      'Update'
                  ),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                      _serviceEnabled = await location.serviceEnabled();
                      _locationData = await location.getLocation();
                      await DataBaseService(uid: user.uid).updateUserData(
                          userData.uid, _currentName ?? userData.name, _locationData.latitude, _locationData.longitude, userData.token,"",userData.profileImage
                      );
                      Navigator.pop(context);
                    }
                  },
                ),

              ],
            ),
            ]
          ));
        } else{
          return Loading();
        }
      }
    );
  }
}
