import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/item.dart';

final itemsProvider = 
  FutureProvider.family<List<Item>, int>((ref, id)async{
    return await Item.all(id);
  });

final newItemProvider = StateProvider((ref) => "");

class ItemIndex extends ConsumerWidget {
  final int id;

  const ItemIndex({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final newItem = ref.watch(newItemProvider.notifier);
    final todoList = ref.watch(itemsProvider(id));
    var _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('シンプルメモ|詳細')),
      body: todoList.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
        data: (list){
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("完了: ${list.where((v) => v.completed).length}"),
                  Text("未完了: ${list.where((v) => !v.completed).length}"),
                ],
              ),
              Expanded(child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index){
                  return ItemRow(item: list[index], id: id);
                },
              )),
              const Text("メモの追加"),
              TextField(
                onChanged: (value) => newItem.state = value,
                controller: _controller,
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('登録'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    List<String> splited = newItem.state.split("\n");
                    for(int i = 0; i < splited.length; i++){
                      if(splited[i].isNotEmpty){
                        Item.insert(id, splited[i]);
                      }
                    }
                    newItem.state = "";
                    _controller.clear();
                    ref.refresh(itemsProvider(id));
                  },
                )
              ),
            ]
          );
        }
      )
    );
  }
}

class ItemRow extends ConsumerWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Item item;

  final int id;
  const ItemRow({Key? key, required this.item, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Row(
        children: [
          item.completed ? const Icon(Icons.check) : const Icon(Icons.check_box_outline_blank),
          Text(
            item.text,
            style: item.completed ? const TextStyle(decoration: TextDecoration.lineThrough) : null
          ),
        ]
      ),
      trailing: TextButton(
        onPressed: () {
          Item.delete(item.id);
          ref.refresh(itemsProvider(id));
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          onPrimary: Colors.white,
          shape: const StadiumBorder(),
        ),
        child: const Icon(Icons.delete)
      ),
      onTap: () {
        Item.toggleComplete(item.id, item.completed);
        ref.refresh(itemsProvider(item.noteId));
      }
    );
  }
}