import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/cubit/task_stats.dart';

import '../cubit/task_cubit.dart';
import '../database/local/db_helper.dart';
import '../models/task.dart';
import '../shard_alongapp/components_reused/constants.dart';
import '../shard_alongapp/components_reused/sliver_custom_app_bar.dart';

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
          AppCubit cubit = AppCubit.get(context);

          List<SpeedDialChild> list = [
            SpeedDialChild(
              child: const Icon(Icons.add_task_sharp),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: ' ADD TASK',
              onTap: () async {
                scaffoldKey.currentState?.showBottomSheet(
                  (context) => buildBottomSheet(
                    context,
                    () async {
                      await _addTasksToDatabase(context);

                      Navigator.pop(context);
                    },
                  ),
                  elevation: 20,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.dark_mode_outlined) : null,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'Theme Mode',
              onTap: () {},
              onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child:
                  !rmicons ? const Icon(Icons.delete_forever_outlined) : null,
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'Delete All',
              visible: true,
              onTap: () async {
                DBHelper.deleteAll().then((value) {
                  cubit.tasksGet();
                  cubit.newTaskList = [];
                  // print("deleted ==>> $value");
                });
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text(("Third Child Pressed"))));
              },
              //onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child:
                  !rmicons ? const Icon(Icons.delete_forever_outlined) : null,
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: cubit.currentIndex == 0
                  ? 'Delete All new'
                  : cubit.currentIndex == 1
                      ? 'Delete All Done'
                      : 'Delete All Archive',
              visible: true,
              onTap: () async {
                DBHelper.deleteFrom(
                  cubit.currentIndex == 0
                      ? 'new'
                      : cubit.currentIndex == 1
                          ? 'done'
                          : 'archive',
                ).then((value) {
                  AppCubit.get(context).tasksGet();
                  print("deleted ==>> $value");
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(("Third Child Pressed"))));
              },
              onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
            ),
          ];
          return Scaffold(
            key: scaffoldKey,
            body: CustomScrollView(
              slivers: [
                sliverCustomAppBar(context, list),
                SliverList(
                  delegate: SliverChildListDelegate(
                      [cubit.screens[cubit.currentIndex]]),
                ),
              ],
            ),
            bottomNavigationBar: _bottomNavigationBar(context),
          );
        },
      ),
    );
  }


  _addTasksToDatabase(context) async {
    //الفاليو هو الاي دي هنا
    DBHelper.insertToDtaBase(
      Task(
        title: titleController.text,
        note: noteController.text,
        status: 'new',
        date: DateFormat.yMd().format(AppCubit.get(context).selectedDateTime),
        startTime: AppCubit.get(context).startTime,
        endTime: AppCubit.get(context).endTime,
        color: AppCubit.get(context).selectedColor,
        remind: AppCubit.get(context).selectedRemind,
        repeat: AppCubit.get(context).selectedRepeat,
      ),
    ).then((value) async {
      AppCubit.get(context).tasksGet();
      print("id inserted into it ==>> $value");
    });
  }



  ///خلصنا هنا كده
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
