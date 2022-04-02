import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../cubit/task_cubit.dart';
import '../../cubit/task_stats.dart';
import '../../ui/detaials_page.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

const String columnId = 'id';
const String columnTitle = 'title';
const String columnNote = 'note';
const String columnDate = 'date';
const String columnStartTime = 'startTime';
const String columnEndTime = 'endTime';
const String columnColor = 'color';
const String columnState = 'state';
const String columnStatus = 'status';
const String columnRemind = 'remind';
const String columnRepeat = 'repeat';
const String textType = 'TEXT NOT NULL';
const String integerType = 'INTEGER NOT NULL';
const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';


ConditionalBuilder buildConditionalBuilder(cubitList, cubit) {
  return ConditionalBuilder(
    condition: cubitList.isNotEmpty,
    builder: (context) =>
        SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * .8,
          child: ListView.builder(
              itemBuilder: (context, index) {
                final Map<String, dynamic> item = cubitList[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Details(
                              item: item,
                            )));
                  },
                  child: Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),

                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: DismissiblePane(onDismissed: () {
                        cubit.tasksDelete(item['id']);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${item['title']} dismissed')));
                      }),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFFFE4A49),
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (BuildContext context) {
                            cubit.tasksDelete(item['id']);
                          },
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) {},
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFF21B7CA),
                          icon: Icons.share,
                          label: 'Edit',
                        ),
                      ],
                    ),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          onPressed: (BuildContext context) {
                            cubit
                                .update(id: item['id'], x: 'archive');
                          },
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFF7BC043),
                          icon: Icons.archive,
                          label: 'Archive',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            cubit
                                .update(id: item['id'], x: 'done');
                          },
                          backgroundColor: Colors.transparent,
                          foregroundColor: Color(0xFF0392CF),
                          icon: Icons.save,
                          label: 'Done',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: Card(
                      elevation: 20,
                      color: Colors.blueGrey.shade900.withOpacity(.5),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                              Colors.teal.shade900.withOpacity(.5),
                              child: Text('${index + 1}'),
                              radius: 40,
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Title : \n${cubit
                                        .newTaskList[index]['title']}',
                                    style: GoogleFonts.abel(
                                        fontSize: 25,
                                        color: Colors.teal.shade900,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 20),
                                Text(
                                  'Date : ${cubit.newTaskList[index]['date']}  '
                                      '  Time :${cubit
                                      .newTaskList[index]['startTime']}',
                                  style:
                                  TextStyle(color: Colors.teal.shade300),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: cubit.newTaskList.length),
        ),
    fallback: (context) =>
        SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * .7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                trailing: Icon(
                  Icons.emoji_people,
                  size: 150,
                  color: Colors.blueGrey.shade400,
                ),
                subtitle: Text(
                  'Go Add One',
                  style: GoogleFonts.syneMono(
                      textStyle: const TextStyle(
                          fontSize: 25, color: Colors.blueGrey)),
                ),
                title: Text('No New Tasks Yet!',
                    style: GoogleFonts.syneMono(
                        textStyle: const TextStyle(
                            fontSize: 25, color: Colors.blueGrey))),
              ),
            ],
          ),
        ),
  );
}

BlocConsumer<AppCubit, AppState> buildBottomSheet(context, onPressed) {
  return BlocConsumer<AppCubit, AppState>(
    listener: (BuildContext context, AppState state) {},
    builder: (BuildContext context, AppState state) {
      return Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300.withOpacity(.3)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(60),
            topLeft: Radius.circular(50),
          ),
          color: Colors.black.withOpacity(.6),
        ),
        height: MediaQuery
            .of(context)
            .size
            .height * .53,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              //alignment:Alignment.centerLeft,
              height: 3,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[500]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.cancel_presentation,
                      color: Colors.blueGrey,
                    )),
                Text(' Add Task Details',
                    style: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.blueGrey.shade900),
                        foregroundColor: MaterialStateProperty.all(
                            Colors.blueGrey.shade300)),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              //alignment:Alignment.centerLeft,
              height: 2,
              width: 155,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[500]),
            ),
            SizedBox(
              width: 350,
              height: 300,
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This Field Required';
                      }
                      return null;
                    },
                    controller: titleController,
                    lable: 'Title',
                    icon: const Icon(
                      Icons.title,
                      color: Colors.blueGrey,
                      size: 30,
                    ),
                  ),
                  buildTextFormField(
                    icon: const Icon(
                      Icons.sticky_note_2_outlined,
                      color: Colors.blueGrey,
                      size: 30,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This Field Required';
                      }
                      return null;
                    },
                    controller: noteController,
                    lable: 'Note',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DateTime',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      buildTextFormField(
                        onTap: () {
                          AppCubit.get(context).getDateFromUser(context);
                        },
                        enabled: false,
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.blueGrey,
                          size: 30,
                        ),
                        lable: DateFormat.yMd()
                            .format(AppCubit
                            .get(context)
                            .selectedDateTime),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'StartTime',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            buildTextFormField(
                                enabled: false,
                                icon: const Icon(
                                  Icons.timer,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                                lable: AppCubit
                                    .get(context)
                                    .startTime,
                                onTap: () async {
                                  await AppCubit.get(context).getTimeFromUser(
                                      isStartTime: true, context: context);
                                }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EndTime',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            buildTextFormField(
                                enabled: false,
                                icon: const Icon(
                                  Icons.timer,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                                lable: AppCubit
                                    .get(context)
                                    .endTime,
                                onTap: () async {
                                  await AppCubit.get(context).getTimeFromUser(
                                      isStartTime: false, context: context);
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Reminder',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                buildTextFormField(
                                  enabled: false,
                                  lable: AppCubit
                                      .get(context)
                                      .selectedRemind
                                      .toString(),
                                ),
                              ])),
                      Expanded(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(15),
                          dropdownColor: Colors.blueGrey,
                          onChanged: (int? newValue) {
                            AppCubit.get(context).changeRemindValue(newValue);
                          },
                          icon: const Icon(
                            Icons.av_timer_outlined,
                            color: Colors.blueGrey,
                            size: 26,
                          ),
                          underline: Container(
                            height: 0,
                          ),
                          elevation: 4,
                          items: AppCubit
                              .get(context)
                              .remindList
                              .map(
                                (valueReminded) =>
                                DropdownMenuItem(
                                  value: valueReminded,
                                  child: Text(
                                    "$valueReminded",
                                  ),
                                ),
                          )
                              .toList(),
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Repeat',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                buildTextFormField(
                                  enabled: false,
                                  lable: AppCubit
                                      .get(context)
                                      .selectedRepeat
                                      .toString(),
                                ),
                              ])),
                      Expanded(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(15),
                          dropdownColor: Colors.blueGrey,
                          onChanged: (String? newValue) {
                            AppCubit.get(context).changeRepeatValue(newValue);
                          },
                          icon: const Icon(
                            Icons.repeat,
                            color: Colors.blueGrey,
                            size: 30,
                          ),
                          underline: Container(
                            height: 0,
                          ),
                          elevation: 4,
                          items: AppCubit
                              .get(context)
                              .repeatList
                              .map(
                                (valueReminded) =>
                                DropdownMenuItem(
                                  value: valueReminded,
                                  child: Text(valueReminded),
                                ),
                          )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  buildTextFormField(
                      enabled: false,
                      icon: const Icon(
                        Icons.list,
                        color: Colors.blueGrey,
                        size: 30,
                      ),
                      lable: 'Color',
                      onTap: () async {

                        // raise the [showDialog] widget



                        Color pickerColor = Color(0xff443a49);
                        Color currentColor = Color(0xff443a49);                        showDialog(
                          context: context,
                          builder:(context)=> AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              // child: ColorPicker(
                              //   pickerColor: pickerColor,
                              //   onColorChanged: changeColor,
                              // ),
                              // Use Material color picker:
                              //
                              // child: MaterialPicker(
                              //   pickerColor: pickerColor,
                              //   onColorChanged: changeColor,
                              //   showLabel: true, // only on portrait mode
                              // ),
                              //
                              // Use Block color picker:
                              //
                              child: BlockPicker(
                                availableColors: _defaultColors,
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                              ),
                              //
                              // child: MultipleChoiceBlockPicker(
                              //   pickerColors: currentColors,
                              //   onColorsChanged: changeColors,
                              // ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  // setState(() => currentColor = pickerColor);
                                  // Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
const List<Color> _defaultColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];

final titleController = TextEditingController();
final noteController = TextEditingController();

GestureDetector buildTextFormField(
    {controller, validator, lable, icon, bool? enabled = true, onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.only(left: 5),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600),
        color: Colors.grey.shade500.withOpacity(.1),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: TextFormField(
        enabled: enabled,
        cursorColor: Colors.grey[700],
        controller: controller,
        keyboardType: TextInputType.text,
        readOnly: false,
        style: GoogleFonts.aBeeZee(
          color: Colors.grey.shade50,
          fontSize: 16,
        ),
        validator: validator,
        decoration: InputDecoration(
          suffixIcon: icon,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueGrey.shade400,
                width: 1.5,
              )),
          label: Text(lable),
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ),
    ),
  );
}
// create some values

void changeColor(Color color) {
  // setState(() => pickerColor = color);
}
