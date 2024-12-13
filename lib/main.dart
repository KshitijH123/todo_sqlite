import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqlite/create_todo_widget.dart';
import 'package:todo_sqlite/database/todo_db.dart';
import 'package:todo_sqlite/model/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Todo List'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const TodosPage(), 
    );
  }
}

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  Future<List<Todo>>? futureTodos;
  final TodoDb todoDB = TodoDb();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<Todo>>(
          future: futureTodos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final todos = snapshot.data!;

              return todos.isEmpty
                  ? const Center(
                      child: Text(
                        'No todos..',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        final subtitle = DateFormat('yyyy/MM/dd').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                todo.updatedAt));

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              todo.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(subtitle),
                            trailing: IconButton(
                              onPressed: () async {
                                await todoDB.delete(todo.id);
                                fetchTodos();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (Context) => CreateTodoWidget(
                                  todo: todo,
                                  onSubmit: (title) async {
                                    await todoDB.update(
                                      id: todo.id,
                                      title: title,
                                    );
                                    fetchTodos();
                                    if (!mounted) return;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CreateTodoWidget(
                onSubmit: (title) async {
                  await todoDB.create(title: title);
                  fetchTodos();
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
      );
}
