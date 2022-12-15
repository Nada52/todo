import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/components/constants.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tasks = AppCubit.get(context).tasks;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => AppCubit(),
        builder: (context, state) => ListView.separated(
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    child: Text('${tasks[index]['time']}'),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tasks[index]['title']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${tasks[index]['date']}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 20.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
        itemCount: tasks.length));
  }
}
