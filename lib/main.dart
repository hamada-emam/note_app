import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/cubit/task_cubit.dart';

import 'package:noteapp/shard_alongapp/bloc_observe/bloc_observe.dart';
import 'package:noteapp/ui/home_layout.dart';

import 'database/local/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //to have the all cubit observable
  BlocOverrides.runZoned(
    () {
      AppCubit();
    },
    blocObserver: MyBlocObserver(),
  );
  // to create database
  await DBHelper.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.blueGrey.shade900.withOpacity(.7),
        // iconTheme: IconThemeData(color: Colors.teal.shade700),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedIconTheme: IconThemeData(
            color: Colors.pink.shade800,
            size: 18,
            opacity: .8,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          showUnselectedLabels: true,
          unselectedLabelStyle:
              TextStyle(fontSize: 14, color: Colors.red.shade700),
          selectedLabelStyle:
              TextStyle(fontSize: 16, color: Colors.greenAccent.shade700),
          selectedIconTheme: IconThemeData(
            color: Colors.green.shade800,
            size: 25,
            opacity: .8,
          ),
          showSelectedLabels: true,
        ),
      ),
      home: MyHomePage(),
    );
  }
}
