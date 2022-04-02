import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteapp/cubit/task_cubit.dart';
import 'package:noteapp/cubit/task_stats.dart';

import '../../cubit/task_cubit.dart';
import '../../shard_alongapp/components_reused/constants.dart';

class NewTask extends StatelessWidget {
  NewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (BuildContext context, AppState state) {},
      builder: (BuildContext context, AppState state) {
        AppCubit cubit = AppCubit.get(context);
        return buildConditionalBuilder(cubit.newTaskList,cubit);
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
