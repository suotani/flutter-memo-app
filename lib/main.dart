import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/note/index.dart';


void main() {
  runApp(ProviderScope(child: MyTodoApp()));
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'シンプルメモ',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      //home: Sample2(),
      home: const NoteIndex(),
      //home: MemoList(),
      //home: MyDialog()
    );
  }
}