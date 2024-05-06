import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/todo-bloc/todo_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
          AddTodo(todo),
        );
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
          RemoveTodo(todo),
        );
  }

  alterTodo(int index) {
    context.read<TodoBloc>().add(
          AlterTodo(index),
        );
  }

  bool darkMode = false;

  bool completed = false;

  Brightness? brightness;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
   });
    
  }
  int _selectedIndex = 0;

  void confirmDelete(BuildContext context, Todo todo) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this todo?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(
            color: Colors.red
          ),),
        ),
        TextButton(
          onPressed: () {
            removeTodo(todo);
            Navigator.of(context).pop();
          },
          child: const Text('Delete', style: TextStyle(
            color: Colors.green
          )),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller1 = TextEditingController();
                TextEditingController controller2 = TextEditingController();

                return AlertDialog(
                  title: const Text('Add Todo'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller1,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: 'Title task',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: controller2,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: 'Description',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ))),
                      )
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                        onPressed: () {
                          addTodo(Todo(
                              title: controller1.text,
                              subTitle: controller2.text));
                          controller1.text = '';
                          controller2.text = '';
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Icon(
                            CupertinoIcons.check_mark,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        },
        backgroundColor: darkMode ? Colors.white : Theme.of(context).colorScheme.primary,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: darkMode ? Colors.white : Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget> [
          Switch(
            value: darkMode, 
            onChanged: (value) {
              setState(() {
                darkMode = !darkMode;
              });
            },
            activeColor: Colors.black,
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
          if (state.status == TodoStatus.success) {
            return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, int i) {
                  if ( state.todos[i].isDone && completed) {
                    return Card(
                      color: darkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                confirmDelete(context, state.todos[i]);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            )
                          ],
                        ),
                        child: ListTile(
                          title: Text(state.todos[i].title),
                          subtitle: Text(state.todos[i].subTitle),
                          trailing: Checkbox(
                            checkColor: darkMode ? Colors.white : Colors.black,
                            value: state.todos[i].isDone,
                            activeColor: darkMode ? Colors.black : Colors.white,
                            side:const BorderSide(color: Colors.black),
                            onChanged: (value) {
                              alterTodo(i);
                            },
                          ),
                        ),
                      ),
                    );
                  }

                  if (!completed && !state.todos[i].isDone) {
                    return Card(
                      color: darkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                confirmDelete(context, state.todos[i]);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            )
                          ],
                        ),
                        child: ListTile(
                          title: Text(state.todos[i].title),
                          subtitle: Text(state.todos[i].subTitle),
                          trailing: Checkbox(
                            checkColor: darkMode ? Colors.white : Colors.black,
                            value: state.todos[i].isDone,
                            activeColor: darkMode ? Colors.black : Colors.white,
                            side:const BorderSide(color: Colors.black),
                            onChanged: (value) {
                              alterTodo(i);
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                }
              );
          } else if (state.status == TodoStatus.initial) {
            return const Center(
              child: Text('Initial'),
            );
          } else {
            return const Center(
              child: Text('Else'),
            );
          }
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              completed = false;
            } else if (index == 1) {
              completed = true;
            }
            
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_unchecked),
            label: 'Incompleted',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed',
          ),
        ],
        selectedItemColor: Colors.green,
      ),     
    );
  }
}
