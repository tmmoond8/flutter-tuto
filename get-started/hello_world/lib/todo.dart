
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void main() => runApp(TodoApp());
final _formKey = GlobalKey<FormState>();

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo APp',
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Todo'),
          ),
        ),
        body: Center(
          child: TodoList(),
        ),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  TodoListState createState() => TodoListState();
}

class TodoItem {
  String _title;
  String _desc;
  bool _isDone;

  TodoItem(String title, String desc) {
    this._title = title;
    this._desc = desc;
    this._isDone = false;
  }

  String get title {
    return this._title;
  }

  void set title(title) {
    this._title = title;
  }

  String get desc {
    return this._desc;
  }
  void set desc(desc) {
    this._desc = desc;
  }

  bool get isDone {
    return this._isDone;
  }

  void set isDone(bool isDone) {
    this._isDone = isDone;
  }
}

class TodoListState extends State<TodoList> {
  final _todos = <TodoItem>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  TodoListState() {
    _todos.add(new TodoItem("커피 마시기", "스벅에 가서 아아 먹기"));
    _todos.add(new TodoItem("핸드폰 충전하기", "배터리 20% 이하일 때 핸드폰 충전하기"));
  }

  Widget _buildRow(TodoItem todoItem) {
    return ListTile(
      title: Text(
        todoItem.title,
        style: _biggerFont
      ),
      trailing: GestureDetector(
        child: Icon(
          todoItem.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: todoItem.isDone ? Colors.green : Colors.lightGreen,
        ),
        onTap: () {
          setState(() {
            todoItem.isDone = !todoItem.isDone;
          });
        }
      ),
      onTap: () {
        _intoTodoItem(todoItem);
      },
    );
  }

  Widget _buildTodos() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _todos.length) return Container();
        return _buildRow(_todos[index]);
      },
      itemCount: _todos.length + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTodos(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _moveToCreatePage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
  void _moveToCreatePage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add new Todo'),
            ),
            body: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      key: Key('title'),
                      decoration: const InputDecoration(
                        hintText: 'todo title',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: titleController,
                    ),
                    TextFormField(
                      key: Key('desc'),
                      decoration: const InputDecoration(
                        hintText: 'todo desc',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: descController,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          Toast.show(_todos.length.toString() + titleController.text, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                          setState(() {
                            _todos.add(new TodoItem(titleController.text, descController.text));
                          });
                          // Navigator.pop(context);
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _intoTodoItem(TodoItem todoItem) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text(todoItem.title),
              ),
              body: Center(child: Text(todoItem.desc))
            );
        },
      ),
    );
  }
}