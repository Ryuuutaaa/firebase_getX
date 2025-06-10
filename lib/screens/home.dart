import 'package:firebase_getx/controllers/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoController>(
      init: Get.find<TodoController>(),
      builder: (todoController) {
        todoController.getData();
        return Scaffold(
          body: Center(
            child: todoController.isLoading
                ? const SizedBox(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: todoController.taskList.length,
                    itemBuilder: (contex, index) {
                      return ListTile(
                        title: Text(
                          todoController.taskList[index].task,
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => print("edit"),
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => print("delete"),
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => Get.defaultDialog(
              title: "Add Todo",
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _taskController,
                      decoration: InputDecoration(labelText: 'Task'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await controller.addTodo(
                                _taskController.text.trim(), false);
                            _taskController.clear();
                          } catch (e) {
                            Get.snackbar('Error', 'Failed to save todo: $e');
                          }
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
