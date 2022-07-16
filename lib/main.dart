import 'package:flutter/material.dart';


import 'package:noteapp/ui/screens/home/home_layout.dart';

import 'database/data_handler/db_helper.dart';

void main() async {
  // to create database
  await DBHelper.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

