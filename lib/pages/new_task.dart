import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/cubit/cubit.dart';
import 'package:todo/shared/components/cubit/state.dart';
import 'package:todo/widget/custom_task_bulider.dart';

import 'package:todo/widget/custom_task_item.dart';

import 'package:todo/shared/components/constants.dart';

class NewTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        return task_build(tasks: tasks);
      },
    );
  }
}
