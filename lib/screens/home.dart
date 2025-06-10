import 'package:firebase_getx/controllers/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();

    return Scaffold(
      body: Center(
        child: Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.defaultDialog(
          title: "add todo",
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _taskController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "cannot be empty";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async => await todoController.addTodo(
                      _taskController.text.trim(), false),
                  child: const Text("save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
