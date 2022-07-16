import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/cubit/stats.dart';

import '../database/data_handler/db_helper.dart';
import '../ui/screens/home/moduls/archive_task/archive_task.dart';
import '../ui/screens/home/moduls/done_task/done_task.dart';
import '../ui/screens/home/moduls/new_task/new_task.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

 static ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);
  static bool customDialRoot = false;
  static bool visible = true;
  static bool switchLabelPosition = true;
  static bool extend = false;
  static bool rmicons = false;
  static bool closeManually = false;
  static bool useRAnimation = true;
  static SpeedDialDirection speedDialDirection = SpeedDialDirection.down;
  static Size buttonSize = const Size(56.0, 56.0);
  static Size childrenButtonSize = const Size(56.0, 56.0);
  static FloatingActionButtonLocation selectedfABLocation = FloatingActionButtonLocation.startFloat;
  static bool renderOverlay = false;

  List<Widget> screens = [
    const NewTask(),
    const DoneTask(),
    const ArchiveTask(),
  ];
  List appBar = ['NewTask', 'DoneTask', 'ArchiveTask'];
  int currentIndex = 0;

  appBarr() {
    var bar = appBar[currentIndex];
    emit(appBarr());
    return bar;
  }

  changeScreen(index) {
    currentIndex = index;
    emit(ChangeBottomNaveIndexState());
  }

  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  getTimeFromUser(
      {required bool isStartTime, required BuildContext context}) async {
    await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    ).then((value) {
      String? _formatedTime = value?.format(context);
      if (value != null) {
        if (isStartTime == true) {
          startTime = _formatedTime!;
          emit(StartTimeState());
        } else if (isStartTime == false) {
          endTime = _formatedTime!;
          emit(EndTimeState());
        }
      } else {
        debugPrint(
            "it's null or something wrong! the user go without selecting time ");
      }
    });
  }

  DateTime selectedDateTime = DateTime.now();

  getDateFromUser(context) async {
    await showDatePicker(
            context: context,
            initialDate: selectedDateTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(3000))
        .then((value) {
      if (value != null) {
        selectedDateTime = value;
        emit(DateState());
      } else {
        debugPrint(
            "it's null or something wrong! the user go without selecting date");
      }
    });
  }

  int selectedRemind = 5;
  final List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'None';
  final List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  final int selectedColor = 0;

  changeRemindValue(int? newValue) {
    selectedRemind = newValue!;
    emit(ReminderState());
  }

  changeRepeatValue(String? newValue) {
    selectedRepeat = newValue!;
    emit(ReminderState());
  }

  List<Map<String, dynamic>> newTaskList = [];
  List<Map<String, dynamic>> doneTaskList = [];
  List<Map<String, dynamic>> archiveTaskList = [];

  tasksGet() {
    newTaskList = [];
    doneTaskList = [];
    archiveTaskList = [];
    DBHelper().query().then((value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          newTaskList.add(element);
        } else if (element['status'] == 'done') {
          doneTaskList.add(element);
        } else {
          archiveTaskList.add(element);
        }
      }
      debugPrint('done $doneTaskList');
      debugPrint('archive $archiveTaskList');
      debugPrint('new $newTaskList');

      emit(GetTasksState());
    });
  }

  update({required int id, required String x}) async {
    DBHelper.update(id: id, x: x).then((value) {
      tasksGet();
      emit(AppDatabaseUpdateState());
    });
  }

  edit({required int id, required String x}) async {
    await DBHelper.updateNote(id: id, x: x).then((value) {
      tasksGet();
      emit(AppDatabaseUpdateState());
      emit(ArchiveTasksState());
      emit(DeleteTasksState());
      emit(GetTasksState());
      emit(DoneTasksState());
    });
  }

  tasksDelete(int? id) {
    DBHelper.delete(id).then((value) {
      tasksGet();
      emit((AppDatabaseUpdateState()));
    });
  }

  tasksDeleteFrom(String? status) {
    DBHelper.deleteFrom(status).then((value) {
      tasksGet();
      emit((AppDatabaseUpdateState()));
    });
  }
}

// import 'package:bloc/bloc.dart';
// /// A `CounterCubit` which manages an `int` as its state.
// class CounterCubit extends Cubit<int> {
//   /// The initial state of the `CounterCubit` is 0.
//   /// CounterCubit() : super(0);
//   CounterCubit() : super(0);
//
//   /// When increment is called, the current state
//   /// of the cubit is accessed via `state` and
//   /// a new `state` is emitted via `emit`.
//   /// void increment() => emit(state + 1);
// }
// ///usage into the main function
// /// /// Create a `CounterCubit` instance.
// /*
//  final cubit = CounterCubit();
//
//
//   /// Access the state of the `cubit` via `state`.
//   print(cubit.state); // 0
//
//   /// Interact with the `cubit` to trigger `state` changes.
//   cubit.increment();
//
//   /// Access the new `state`.
//   print(cubit.state); // 1
//
//   /// Close the `cubit` when it is no longer needed.
//   cubit.close();
//   */
// /*
// class MyBlocObserver extends BlocObserver {
//   @override
//   void onCreate(BlocBase bloc) {
//     super.onCreate(bloc);
//     print('onCreate -- ${bloc.runtimeType}');
//   }
//
//   @override
//   void onChange(BlocBase bloc, Change change) {
//     super.onChange(bloc, change);
//     print('onChange -- ${bloc.runtimeType}, $change');
//   }
//
//   @override
//   void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
//     print('onError -- ${bloc.runtimeType}, $error');
//     super.onError(bloc, error, stackTrace);
//   }
//
//   @override
//   void onClose(BlocBase bloc) {
//     super.onClose(bloc);
//     print('onClose -- ${bloc.runtimeType}');
//   }
// }*/
