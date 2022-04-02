import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteapp/shard_alongapp/components_reused/constants.dart';

import '../cubit/task_cubit.dart';
import '../cubit/task_stats.dart';
import '../models/task.dart';

class Details extends StatelessWidget {
  Details({Key? key, required this.item}) : super(key: key);
  final Map<String, dynamic> item;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => AppCubit()..tasksGet(),
        child: BlocConsumer<AppCubit, AppState>(
          listener: (BuildContext context, AppState state) {},
          builder: (BuildContext context, AppState state) {
            AppCubit cubit = AppCubit.get(context);

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                      minLeadingWidth: 100,
                      leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.grey.shade400,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      title: Text(
                        'Task Details',
                        style: GoogleFonts.abel(
                            textStyle: const TextStyle(
                                color: Colors.tealAccent, fontSize: 30)),
                      )),
                  Container(
                    padding: const EdgeInsets.all(20),
                    // margin: const EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * .85,
                    child: ListView(
                      children: [
                        buildText('${item['title']}', 'Title'),
                        GestureDetector(
                          onTap: () {
                            showAlertDialog(
                              context,
                              () {
                                cubit.edit(id: item['id'], x: _controller.text);
                                cubit.tasksGet();
                                Navigator.pop(context);
                              },
                            );
                          },
                          child: buildText('${item['note']}', 'Note'),
                        ),
                        buildText('${item['status']}', 'Status'),
                        buildText('${item['startTime']}', 'Start'),
                        buildText('${item['endTime']}', 'End'),
                        buildText('${item['repeat']}', 'Repeat'),
                        buildText('${item['remind']}', 'Remind'),
                        buildText('${item['date']}', 'Date'),
                        buildText('${item['color']}', 'Color'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }

  showAlertDialog(BuildContext context, onPressed) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("UPDATE"),
      onPressed: onPressed,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.shade900,
      title: const Text("update Note"),
      content: buildTextFormField(
          icon: Icon(Icons.edit),
          lable: 'EditNote',
          controller: _controller,
          validator: (value) {},
          enabled: true),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  buildText(text, avatar) => Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.teal,
            child: Text(avatar),
          ),
          Container(
              alignment: Alignment.centerLeft,
              height: 50,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(15),
              color: Colors.transparent,
              child: Text(
                text,
                style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.blueGrey, fontSize: 20)),
              )),
        ],
      );
}
