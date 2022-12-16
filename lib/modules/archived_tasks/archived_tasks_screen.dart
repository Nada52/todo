import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tasks = AppCubit.get(context).archivedTasks;
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) => AppCubit(),
        builder: (context, state) => tasks.isEmpty ? const Center(child:  Text('archived tasks are empty', style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),)):ListView.separated(
            itemBuilder: (context, index) => Dismissible(
              key:  Key('${tasks[index]['id']}'.toString()),
              onDismissed: (direction){
                tasks.removeAt(tasks[index]['id']);
              },
              child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          child: Text('${tasks[index]['time']}'),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${tasks[index]['title']}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${tasks[index]['date']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                            onPressed: () {
                              AppCubit.get(context).updateData(
                                  status: 'Done', id: tasks[index]['id']);
                            },
                            icon: const Icon(
                              Icons.check_box,
                              color: Colors.green,
                            )),
                        IconButton(
                            onPressed: () {
                              AppCubit.get(context).updateData(
                                  status: 'Archive', id: tasks[index]['id']);
                            },
                            icon: const Icon(
                              Icons.archive,
                              color: Colors.black45,
                            )),
                      ],
                    ),
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
