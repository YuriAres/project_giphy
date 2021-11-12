import 'package:flutter/material.dart';
import 'package:project_giphy/ui/home_page.dart';

main(List<String> args) {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)))),
  ));
}
