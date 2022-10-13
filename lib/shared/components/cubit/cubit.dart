import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/components/cubit/state.dart';

import 'package:todo/pages/archive_task.dart';
import 'package:todo/pages/done_task.dart';
import 'package:todo/pages/new_task.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTaskPage(),
    DoneTaskPage(),
    ArchivePage(),
  ];
  List<String> title = [
    'Tasks',
    'Done Tasks',
    'Archive Task',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        print('data created');

        try {
          await db.execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)');
          print('Table created');
        } catch (error) {
          print('Error when created table ${error.toString()}');
        }
      },
      onOpen: (db) {
        getDataFromDatabase(db);
        print('database opened');
      },
    ).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    try {
      await db.transaction((txn) async {
        int datainserted = await txn.rawInsert(
            'INSERT INTO tasks(title , date, time , status) VALUES("$title" , "$date" , "$time", "new")');
        print('$datainserted inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(db).then((value) {
          newTasks = value;
          print(newTasks);
          emit(AppGetDatabaseState());
        });
      });
    } catch (error) {
      print('Error when insert data ${error.toString()}');
    }
  }

  getDataFromDatabase(db) {
    //to not add the old item in list
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status']== 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    await db.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
      getDataFromDatabase(db);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    
    required int id,
  }) async {
    await db.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getDataFromDatabase(db);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShow = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }
}
