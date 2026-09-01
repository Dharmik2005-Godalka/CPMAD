import 'package:flutter/material.dart';
import 'package:todoapp/models/task.dart';

class ToDoController extends GetxController{
  RxList<Task> tasks = RxList.empty();
}