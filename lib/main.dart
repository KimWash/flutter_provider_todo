import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/Page/Home.dart';
import 'package:provider_tutorial/Provider/todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        // SingleProvider: 한개의 상태 관리만 제공
        create: (BuildContext context) => TodoProvider(),
        child: Home(),
      ),
    );
  }
}
