import 'package:firebase_getx/controllers/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.defaultDialog(
          title: "add todo",
        ),
      ),
    );
  }
}
