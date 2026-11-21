import 'package:flutter/material.dart';

import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/api_call.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController txtTitle = TextEditingController();

  List<Todo> todos = [];
  bool isLoading = true;

  @override
  void initState() 
  {
    super.initState();
    fetchTodos();
  }

  // Fetch todos and refresh the screen
  Future<void> fetchTodos() async 
  {
    try 
    {
      final data = await APICall.fetchTodos();

      if (!mounted) 
      {
        return;
      }

      setState(() 
      {
        todos = data;
        isLoading = false;
      });
    } 
    catch (e) 
    {
      if (!mounted) return;

      setState(() 
      {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching todos: $e')));
    }
  }

  Future<void> addTodo() async 
  {
    if (txtTitle.text.trim().isEmpty) return;

    try 
    {
      await APICall.addTodo(txtTitle.text.trim());

      txtTitle.clear();
      await fetchTodos();
    } 
    catch (e) 
    {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding todo: $e')));
    }
  }

  @override
  void dispose() 
  {
    txtTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: txtTitle,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => addTodo(),
                  ),
                ),
              ),
              IconButton(onPressed: addTodo, icon: const Icon(Icons.add)),
            ],
          ),

          // Todo list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : todos.isEmpty
                ? const Center(child: Text('No todos found'))
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) 
                    {
                      final todo = todos[index];

                      return CheckboxListTile(
                        value: todo.completed,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) async 
                        {
                          if (value == null) return;

                          try {
                            await APICall.updateTodo(todo.id, value);

                            await fetchTodos();
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error updating todo: $e'),
                              ),
                            );
                          }
                        },
                        title: Text(
                          todo.task,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        secondary: IconButton
                        (
                          onPressed: () async 
                          {
                            try {
                              await APICall.deleteTodo(todo.id);
                              await fetchTodos();
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar
                              (
                                SnackBar(
                                  content: Text('Error deleting todo: $e'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
