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
                                onPressed: () => addTaskDialog(
                                    todocontroller,
                                    'Update Task',
                                    todoController.taskList[index].id),
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
            onPressed: () async =>
                await addTaskDialog(todocontroller, "Add Todo", ""),
          ),
        );
      },
    );
  }

  void addTaskDialog(
      TodoController todocontroller, String title, String id) async {
    Get.defaultDialog(
      title: title,
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
              onPressed: addTask,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Get.find<TodoController>()
            .addTodo(_taskController.text.trim(), false, id);
        _taskController.clear();
      } catch (e) {
        Get.snackbar('Error', 'Failed to save todo: $e');
      }
    }
  }
}
