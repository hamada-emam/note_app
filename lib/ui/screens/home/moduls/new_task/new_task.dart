import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/cubit/cubit.dart';
import 'package:noteapp/cubit/stats.dart';
import 'package:noteapp/ui/components/managers/conestants_manager.dart';

class NewTask extends StatelessWidget {
  const NewTask({Key? key}) : super(key: key);

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
