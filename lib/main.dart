import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/todo_list_provider.dart';

import 'model/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoListProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App', home: TodoList()),
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoListProvider>(context);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  String newTitle = '';
                  return AlertDialog(
                    title: const Text('Add Todo'),
                    content: TextField(
                      autofocus: true,
                      onChanged: (value) {
                        newTitle = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Enter todo title...'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Add'),
                        onPressed: () {
                          if (newTitle.isNotEmpty) {
                            todoProvider.add(Todo(title: newTitle));
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Todo App'),
        ),
        body: ListView.builder(
          itemCount: todoProvider.todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = todoProvider.todos[index];
            return Card(
              child: Dismissible(
                key: Key(todo.title),
                direction: DismissDirection.horizontal,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
                confirmDismiss: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          String newTitle = todo.title;
                          return AlertDialog(
                            title: const Text('Edit Todo'),
                            content: TextField(
                              autofocus: true,
                              onChanged: (value) {
                                newTitle = value;
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Enter new title...'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  todoProvider.edit(todo, Todo(title: newTitle));
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Todo'),
                            content: const Text(
                                'Are you sure you want to delete this todo?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  todoProvider.remove(todo);
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          );
                        });
                  }
                },
                child: CheckboxListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  value: todo.completed,
                  onChanged: (bool? newValue) {
                    todoProvider.toggleCompleted(todo);
                  },
                ),
              ),
            );
          },
        ));
  }
}
