import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  late Database database;
  List<Map> tasks = [];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when creating table${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDatabaseState());
        });
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

   insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());


      }).catchError((error) {
        print('error when inserting new record ${error.toString()}');
      });
      getDataFromDatabase(database).then((value){
        tasks = value;
        print(tasks);

        emit(AppGetDatabaseState());
      });
    });
  }


  Future<List<Map>> getDataFromDatabase(database) async {
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks');

  }

  Future<int> updateData()async{
    return await database.rawUpdate('UPDATE Test SET name = ?, value = ? WHERE name = ?',
        ['updated name', '9876', 'some name']);
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShown, required IconData icon}) {

    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());

  }
}
