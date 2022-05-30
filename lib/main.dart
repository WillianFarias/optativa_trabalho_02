import 'package:flutter/material.dart';
import 'package:trabalho_willian_farias/view/ListaDisciplina.dart';

void main() {
  runApp((MaterialApp(
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 0, 170, 255),
//accentColor: Colors.blueAccent[700],
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.blueAccent,
          ),
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueAccent[700],
              textTheme: ButtonTextTheme.primary)),
      home: Home(),
      debugShowCheckedModeBanner: false)));
}
