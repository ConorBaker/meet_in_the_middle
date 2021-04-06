import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/home.dart';
import 'package:meet_in_the_middle/Pages/view_bad_place.dart';
import 'package:meet_in_the_middle/Pages/view_safe_places.dart';

class CategorySelector extends StatefulWidget {
  final int selectedIndex;

  CategorySelector(this.selectedIndex);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categories = ['Users','Safe Places', 'No Go Zones'];
  @override
  Widget build(BuildContext context) {
    int selectedIndex = widget.selectedIndex;
    return Container(
      height: 90,
      color : Color.fromRGBO(163,217,229,1),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  selectedIndex = index;
                });
                if(index == 0){
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                  return Home();
                }else if(index == 1){
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => safe_places()),
                  );
                  return safe_places();
                }else if(index == 2){
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => bad_places()),
                  );
                  return bad_places();
                }else if(index == 3){

                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20,
                ),
                child: Text(categories[index],style: TextStyle(
                  color : index == selectedIndex ? Colors.white : Colors.white60,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2
                ),),
              ),
            );
          }),
    );
  }
}
