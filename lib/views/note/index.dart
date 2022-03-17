import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/note.dart';
import 'show.dart';

final commentsProvider = 
  FutureProvider<List<Note>>((ref)async{
    return await Note.all();
  });

final newNoteProvider = StateProvider((ref) => "");

class NoteIndex extends ConsumerWidget {
  const NoteIndex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final newNote = ref.watch(newNoteProvider.notifier);
    final todoList = ref.watch(commentsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('シンプルメモ')),
      body: todoList.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
        data: (list){
          return Column(
            children: [
              Expanded(child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index){
                  return NoteRow(note: list[index]);
                },
              )),
              Row(children: [
                Expanded(child:
                  TextField(
                    onChanged: (value) => newNote.state = value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                ,),
                ElevatedButton(
                  child: const Text('登録'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Note.insert(newNote.state);
                    newNote.state = "";
                    ref.refresh(commentsProvider);
                  },
                ),
              ],)
            ]
          );
        }
      )
    );
  }
}

class NoteRow extends ConsumerWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Note note;
  const NoteRow({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(note.title),
      trailing: TextButton(
        onPressed: () {
          Note.delete(note.id);
          ref.refresh(commentsProvider);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          onPrimary: Colors.white,
          shape: const StadiumBorder(),
        ),
        child: const Icon(Icons.delete)
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return ItemIndex(id: note.id);
          }),
        );
      },
    );
  }
}