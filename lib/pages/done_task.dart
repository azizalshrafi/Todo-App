import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo/shared/components/cubit/cubit.dart';
import 'package:todo/shared/components/cubit/state.dart';
import 'package:todo/widget/custom_task_bulider.dart';
import 'package:todo/widget/custom_task_item.dart';

class DoneTaskPage extends StatelessWidget {
  const DoneTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}

class tasksBuilder extends StatelessWidget {
  const tasksBuilder({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<Map> tasks;

  @override
  Widget build(BuildContext context) {
    return task_build(tasks: tasks);
  }
}

