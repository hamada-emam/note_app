// ignore_for_file: slash_for_doc_comments, must_be_immutable

import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:noteapp/cubit/stats.dart';

import 'package:noteapp/ui/screens/home/widgets/speed_dial.dart';

import '../../../cubit/cubit.dart';


class MyHomePage extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..tasksGet(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {},
        builder: (BuildContext context, AppState state) {
          return SafeArea(
            child: Scaffold(
              key: scaffoldKey,
              body: PageView(children: [
                AppCubit.get(context)
                    .screens[AppCubit.get(context).currentIndex]
              ]),
              bottomNavigationBar: _bottomNavigationBar(context),
              floatingActionButton: Container(
                padding: const EdgeInsets.only(top: 100.0),
                child: DraggableFab(
                  securityBottom: 200,
                  child: floatingActionbuttonAnimate(context, scaffoldKey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // to swap between pages
  BottomNavigationBar _bottomNavigationBar(context) {
    return BottomNavigationBar(
      elevation: 50,
      onTap: (index) {
        AppCubit.get(context).changeScreen(index);
      },
      currentIndex: AppCubit.get(context).currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add_task_sharp),
          label: 'NEW',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.file_download_done_outlined),
          label: 'DONE',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.archive_outlined),
          label: 'ARCHIVED',
        ),
      ],
    );
  }
}
