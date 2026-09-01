import 'dart:developer';
import 'packages:get/get.dart';

import 'package:flutter/material.dart';
import 'package:todoapp/controllers/todo_controller.dart';
import 'package:todoapp/models/task.dart';

class TodoScreen extends StatelessWidget {
  TextEditingController txtTitle = TextEditingController();
  ToDoController todocontroller = Get.put(ToDoController());
  int selInd = -1;
  bool isSel = false;
  @override
  Widget build(BuildContext context) {
    log('From build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: txtTitle,
                  decoration: InputDecoration(
                    hintText: "Enter title of todo",
                    labelText: "Title",
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  print(txtTitle.text);
                  if (txtTitle.text.isNotEmpty) {
                    if (selInd == -1) {
                      tasks.add(Task(txtTitle.text,false));
                    } else {
                      tasks[selInd].title= txtTitle.text;
                      selInd = -1;
                      
                    }

                    txtTitle.text = "";
                    // setState(() {});
                  }
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                leading: Checkbox(value: tasks[index].isCompleted, 
                onChanged: (value) {
                  tasks[index].isCompleted = value!;
                  // setState(() {});
                }),
                title: Text(tasks[index].title),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          txtTitle.text = tasks[index].title;
                          selInd = index;
                          // setState(() {});
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          tasks.removeAt(index);
                          // setState(() {});
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: tasks.length,
            ),
          ),
        ],
      ),
    );
  }
}