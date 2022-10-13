


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/pages/archive_task.dart';
import 'package:todo/pages/done_task.dart';
import 'package:todo/pages/new_task.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:todo/shared/components/cubit/cubit.dart';
import 'package:todo/shared/components/cubit/state.dart';

class HomePage extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  // AppCubit cubit = AppCubit.get(context);

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                AppCubit.get(context).title[AppCubit.get(context).currentIndex],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'archive',
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (AppCubit.get(context).isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) {
                          return Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'title must not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Task Title'),
                                      prefixIcon: Icon(Icons.title),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'time must not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Task Time'),
                                      prefixIcon:
                                          Icon(Icons.watch_later_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then(
                                        (value) => timeController.text =
                                            value!.format(context).toString(),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'date must not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Task Date'),
                                      prefixIcon: Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-10-23'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                        AppCubit.get(context).changeBottomSheetState(
                            isShow: false, icon: Icons.edit);
                      });

                  AppCubit.get(context).changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                AppCubit.get(context).fabIcon,
              ),
            ),
          );
        },
      ),
    );
  }
}
