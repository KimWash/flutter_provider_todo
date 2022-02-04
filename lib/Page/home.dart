import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/Model/todo.dart';
import 'package:provider_tutorial/Provider/todo_provider.dart';
import 'package:uuid/uuid.dart';

final dateFormat = DateFormat("yy/MM/dd HH:mm");

class Home extends StatelessWidget {
  final TextEditingController _todoInputController = TextEditingController();

  Home({Key? key}) : super(key: key);
  TodoProvider? _todoProvider;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    _todoProvider = Provider.of<TodoProvider>(context,
        listen: false); // Listen은 대부분 경우에 꺼주기!
    _todoProvider!.loadTodos();
    debugPrint("rebuilt");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Provider Tutorial"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TodoProvider>(
          builder: (context, provider, child) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int idx) {
                return TodoItem(idx: idx, todo: provider.todos[idx]);
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: provider.todos.length,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.only(bottom: 28, left: 20, right: 20),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: TextField(
                controller: _todoInputController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () async {
                  _selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), // 초깃값
                    firstDate: DateTime.now(), // 시작일
                    lastDate: DateTime(2100), // 마지막일
                    builder: (context, child) => child!,
                  );
                  _selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                },
                icon: const Icon(Icons.calendar_today),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  DateTime? currentDateTime = null;
                  if (_selectedDate != null && _selectedTime != null) {
                    currentDateTime = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    );
                  }
                  _todoProvider!.add(Todo(
                    id: const Uuid().v1(),
                    name: _todoInputController.text,
                    deadline: currentDateTime,
                    isDone: false,
                  ));
                  _todoInputController.clear();
                  _selectedDate = null;
                  _selectedTime = null;
                },
                icon: const Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final int idx;
  final Todo todo;

  TodoItem({
    Key? key,
    required this.idx,
    required this.todo,
  }) : super(key: key);

  TodoProvider? _todoProvider;

  @override
  Widget build(BuildContext context) {
    _todoProvider = Provider.of<TodoProvider>(
      context,
      listen: false,
    );
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
        color: Colors.red,
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
        color: Colors.red,
      ),
      onDismissed: (direction) {
        _todoProvider!.remove(idx);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(todo.name),
              Text(todo.deadline != null
                  ? "${dateFormat.format(todo.deadline!)} 까지"
                  : "기한 없음"),
            ],
          ),
          Checkbox(
            value: todo.isDone,
            onChanged: (value) {
              _todoProvider!.toggleDone(idx);
            },
          ),
        ],
      ),
    );
  }
}
