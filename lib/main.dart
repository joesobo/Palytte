import 'package:palytte/components/theme/custom_theme.dart';
import 'package:palytte/screens/home_page.dart';
import 'package:palytte/utilities/my_themes.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  CustomTheme(
    initialThemeKey: MyThemeKeys.Dark,
    child: MyApp(),
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: CustomTheme.of(context),
      home: HomePage(),
    );
  }
}
