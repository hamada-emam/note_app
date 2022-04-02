import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteapp/cubit/task_cubit.dart';
import 'package:noteapp/cubit/task_stats.dart';

import '../../cubit/task_cubit.dart';
import '../../ui/detaials_page.dart';

class DoneTask extends StatelessWidget {
  const DoneTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (BuildContext context, AppState state) {},
      builder: (BuildContext context, AppState state) {
        AppCubit cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.doneTaskList.isNotEmpty,
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * .8,
            child: ListView.builder(
                itemBuilder: (context, index) {
                  final Map<String, dynamic> item =
                      AppCubit.get(context).doneTaskList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Details(
                                item: item,
                              )));
                    },
                    child: Slidable(
                      // Specify a key if the Slidable is dismissible.
                      key: const ValueKey(2),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const BehindMotion(),

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
                              AppCubit.get(context)
                                  .update(id: item['id'], x: 'archive');
                            },
                            backgroundColor: Colors.transparent,
                            foregroundColor: const Color(0xFF7BC043),
                            icon: Icons.archive,
                            label: 'Archive',
                          ),
                          SlidableAction(
                            onPressed: (BuildContext context) {
                              AppCubit.get(context).update(
                                  id: item['id'],
                                  x: item['status'] == 'done' ? 'new' : 'done');
                            },
                            backgroundColor: Colors.transparent,
                            foregroundColor: const Color(0xFF0392CF),
                            icon: Icons.save,
                            label: item['status'] == 'done' ? 'New' : 'Done',
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
                                      'Title : \n${AppCubit.get(context).doneTaskList[index]['title']}',
                                      style: GoogleFonts.abel(
                                          fontSize: 25,
                                          color: Colors.teal.shade900,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Date : ${AppCubit.get(context).doneTaskList[index]['date']}  '
                                    '  Time :${AppCubit.get(context).doneTaskList[index]['startTime']}',
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
                itemCount: AppCubit.get(context).doneTaskList.length),
          ),
          fallback: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * .7,
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
                  title: Text('No Done Tasks Yet!',
                      style: GoogleFonts.syneMono(
                          textStyle: const TextStyle(
                              fontSize: 25, color: Colors.blueGrey))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container buildBackGroundLeft() {
    return Container(
      color: Colors.greenAccent.shade700,
      child: const Padding(
        padding: EdgeInsets.only(left: 30.0),
        child: Icon(
          Icons.archive_outlined,
          size: 30,
        ),
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Container buildBackGroundRight() {
    return Container(
      color: Colors.redAccent.shade700,
      child: const Padding(
        padding: EdgeInsets.only(right: 30.0),
        child: Icon(
          Icons.delete_forever_outlined,
          size: 30,
          color: Colors.black,
        ),
      ),
      alignment: Alignment.centerRight,
    );
  }
}
