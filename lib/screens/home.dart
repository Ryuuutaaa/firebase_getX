import 'package:firebase_getx/controllers/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _taskController;
  late TodoController todoController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    todoController = Get.find<TodoController>();
    todoController.getData(); // Only called once
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Todo List'),
          ),
          body: Center(
            child: controller.isLoading
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: controller.taskList.length,
                    itemBuilder: (context, index) {
                      final task = controller.taskList[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task.isDone, // Perbaikan 1: Tambahkan value
                          onChanged: (value) => todoController.addTodo(
                              task.task, // Perbaikan 2: Gunakan task langsung
                              value ?? false, // Perbaikan 3: Handle null value
                              task.id),
                        ),
                        title: Text(task.task),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => addTaskDialog(task.id),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    todoController.deleteTask(task.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => addTaskDialog(""),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void addTaskDialog(String id) {
    _taskController.clear();
    if (id.isNotEmpty) {
      final task = todoController.taskList.firstWhere((e) => e.id == id);
      _taskController.text = task.task;
    }

    Get.defaultDialog(
      title: id.isEmpty ? "Add Task" : "Update Task",
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'Task'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  addTask(id), // Perbaikan 4: Panggil addTask yang sudah ada
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addTask(String id) async {
    if (_formKey.currentState!.validate()) {
      try {
        await todoController.addTodo(
          _taskController.text.trim(),
          id.isNotEmpty // Perbaikan 5: Periksa status isDone hanya jika mengupdate
              ? todoController.taskList
                  .firstWhere(
                    (e) => e.id == id,
                    orElse: () => TaskModel(id: '', task: '', isDone: false),
                  )
                  .isDone
              : false,
          id,
        );
        Get.back();
        _taskController.clear();
      } catch (e) {
        Get.snackbar('Error', 'Failed to save todo: $e');
      }
    }
  }

  // Perbaikan 6: Hapus metode deleteTask yang tidak perlu karena sudah menggunakan controller langsung
}
