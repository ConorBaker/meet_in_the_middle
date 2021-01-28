import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/services/database.dart';

class PictureSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> pictures = ['assets/Man1.png','assets/Man2.png', 'assets/Man3.png','assets/Woman1.png','assets/Woman2.png', 'assets/Woman3.png'];
    return Column(
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
              return Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () async {
                    return pictures[index];
                  },
                  child: CircleAvatar(
                    radius: 35.0,
                    backgroundImage: AssetImage(pictures[index]),
                  ),
                ),
              );
              }),
        )
      ],
    );
  }
}
