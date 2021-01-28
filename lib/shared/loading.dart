import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(163,217,229,1),
      appBar: AppBar(
        title: Text('Meet In The Middle'),
        backgroundColor: Color.fromRGBO(163,217,229,1),
        elevation: 0.0,
      ),
      body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(242,243,245,1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
              )),
        child: Center(
          child: SpinKitSquareCircle(
            color: Color.fromRGBO(163,217,229,1),
            size: 50,
          )
        )
      ),
    );
  }
}

