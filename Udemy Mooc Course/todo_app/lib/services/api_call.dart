import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class APICall 
{
  static const String baseUrl =
      'https://node-todo-api-yjo3.onrender.com/todos/';

  static Future<List<Todo>> fetchTodos() async 
  {
    log('from fetchTodos');

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) 
    {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((item) => Todo.fromJson(item)).toList();
    } 
    else 
    {
      throw Exception('Failed to fetch todos: ${response.statusCode}');
    }
  }

  static Future<void> addTodo(String task) async 
  {
    final response = await http.post
    (
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'task': task, 'completed': false}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) 
    {
      throw Exception('Failed to add todo: ${response.statusCode}');
    }
  }

  static Future<void> updateTodo(String id, bool completed) async 
  {
    final response = await http.patch
    (
      Uri.parse('$baseUrl$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'completed': completed}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) 
    {
      throw Exception('Failed to update todo: ${response.statusCode}');
    }
  }

  static Future<void> deleteTodo(String id) async 
  {
    final response = await http.delete(Uri.parse('$baseUrl$id'));

    if (response.statusCode < 200 || response.statusCode >= 300) 
    {
      throw Exception('Failed to delete todo: ${response.statusCode}');
    }
  }
}
