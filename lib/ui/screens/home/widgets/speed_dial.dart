import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/cubit/cubit.dart';

import '../../../../database/data_handler/db_helper.dart';
import '../../../../database/models/task.dart';
import '../../../components/managers/conestants_manager.dart';

SpeedDial floatingActionbuttonAnimate(BuildContext context, scaffoldKey) {
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
      child: !AppCubit.rmicons ? const Icon(Icons.dark_mode_outlined) : null,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      label: 'Theme Mode',
      onTap: () {},
      onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
    ),
    SpeedDialChild(
      child:
          !AppCubit.rmicons ? const Icon(Icons.delete_forever_outlined) : null,
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      label: 'Delete All',
      visible: true,
      onTap: () async {
        DBHelper.deleteAll().then((value) {
          cubit.tasksGet();
          cubit.newTaskList = [];
          debugPrint("deleted ==>> $value");
        });
      },
      //onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
    ),
    SpeedDialChild(
      child:
          !AppCubit.rmicons ? const Icon(Icons.delete_forever_outlined) : null,
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
          debugPrint("deleted ==>> $value");
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(("Third Child Pressed"))));
      },
      onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
    ),
  ];

  return SpeedDial(
    //backgroundColor: Colors.blueGrey.shade900,
    animatedIcon: AnimatedIcons.menu_close,
    animatedIconTheme: const IconThemeData(size: 25.0),
    // / This is ignored if animatedIcon is non null
    child: const Text("open"),
    activeChild: const Text("close"),
    icon: Icons.add,
    activeIcon: Icons.close,
    spacing: 3,
    openCloseDial: AppCubit.isDialOpen,
    childPadding: const EdgeInsets.all(5),
    spaceBetweenChildren: 4,
    dialRoot: AppCubit.customDialRoot
        ? (ctx, open, toggleChildren) {
            return ElevatedButton(
              onPressed: toggleChildren,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[900],
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              ),
              child: const Text(
                "Custom Dial Root",
                style: TextStyle(fontSize: 17),
              ),
            );
          }
        : null,
    buttonSize: AppCubit.buttonSize,
    // it's the SpeedDial size which defaults to 56 itself
    // iconTheme: IconThemeData(size: 22),
    label: AppCubit.extend ? const Text("Open") : null,
    // The label of the main button.
    /// The active label of the main button, Defaults to label if not specified.
    activeLabel: AppCubit.extend ? const Text("Close") : null,

    /// Transition Builder between label and activeLabel, defaults to FadeTransition.
    // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
    /// The below button size defaults to 56 itself, its the SpeedDial childrens size
    childrenButtonSize: AppCubit.childrenButtonSize,
    visible: AppCubit.visible,
    direction: AppCubit.speedDialDirection,
    switchLabelPosition: AppCubit.switchLabelPosition,

    /// If true user is forced to close dial manually
    closeManually: AppCubit.closeManually,

    /// If false, backgroundOverlay will not be rendered.
    renderOverlay: AppCubit.renderOverlay,
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    onOpen: () => debugPrint('OPENING DIAL'),
    onClose: () => debugPrint('DIAL CLOSED'),
    useRotationAnimation: AppCubit.useRAnimation,
    tooltip: 'Open Speed Dial',
    heroTag: 'speed-dial-hero-tag',
    // foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    activeForegroundColor: Colors.red,
    activeBackgroundColor: Colors.blueGrey.shade900,
    elevation: 20.0,
    isOpenOnStart: false,
    animationSpeed: 100,
    shape: AppCubit.customDialRoot
        ? const RoundedRectangleBorder()
        : const StadiumBorder(),
    // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    children: list,
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
    debugPrint("id inserted into it ==>> $value");
  });
}
