import 'dart:convert';

import 'package:colorite/database/database_helper.dart';
import 'package:colorite/models/palette.dart';
import 'package:flutter/material.dart';

class CustomPalettePopup extends StatelessWidget {
  List<Color> colorList = [
    Colors.grey[100],
    Colors.grey[200],
    Colors.grey[300],
    Colors.grey[400],
    Colors.grey[500],
  ];

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance;
    String value;

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Center(child: Text('Custom Color Palette')),
      content: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          height: 225,
          child: Column(
            children: <Widget>[
              Row(
                children: createColorButton(colorList, context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (text) {
                    value = text;
                  },
                  decoration: new InputDecoration(
                    labelText: "Enter Name",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () async {
                  //convert color list to hex list
                  List<String> myColorList = [];
                  for (Color color in colorList) {
                    myColorList.add(color.value
                        .toRadixString(16)
                        .substring(2)
                        .toUpperCase());
                  }

                  //create new palette
                  Palette p = new Palette(
                      name: value, myColorList: jsonEncode(myColorList));
                  
                  Map<String, dynamic> row = p.toJson();
                  
                  //insert new row to database
                  final id = await dbHelper.insert(row);
                  print('inserted row id: $id');
                  print('inserted row name: ${p.name}');
                  print('inserted row list: ${p.myColorList}');
                  Navigator.pop(context);
                },
                color: Colors.blueGrey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //decides which button based on order
  List<Widget> createColorButton(List<Color> colorList, BuildContext context) {
    List<Widget> widgetList = [];
    int count = 0;

    for (Color color in colorList) {
      //first color
      if (colorList[0] == color && count == 0) {
        widgetList.add(
          radiusButton(
            color,
            BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
            context,
          ),
        );
      }
      //last color
      else if (colorList[colorList.length - 1] == color &&
          count == colorList.length - 1) {
        widgetList.add(
          radiusButton(
            color,
            BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            context,
          ),
        );
        // other colors
      } else {
        widgetList.add(
          radiusButton(
            color,
            null,
            context,
          ),
        );
      }
      count++;
    }
    return widgetList;
  }

  //created button with changable radius
  Widget radiusButton(Color color, BorderRadius border, BuildContext context) {
    return Expanded(
      child: Material(
        elevation: 3,
        color: Colors.transparent,
        shadowColor: Colors.grey[800],
        child: FlatButton(
          onPressed: () {
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return ColorInfoPopup(color: color);
            //   },
            // );
          },
          padding: EdgeInsets.all(0),
          child: Container(
            height: 40,
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              borderRadius: border,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
