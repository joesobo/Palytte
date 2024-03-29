import 'package:palytte/utilities/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  
  //loads accent color from shared preferences
  Future<Color> loadColor(String db, Color defaultColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ColorHelper colorHelper = new ColorHelper();

    String hexString = prefs.getString(db);
    Color tempColor;
    if (hexString != null) {
      tempColor = colorHelper.fromHex(hexString);
      return tempColor;
    } else {
      return defaultColor;
    }
  }
}
