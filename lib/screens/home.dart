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
    todoController.getData();
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
                          value: task.isDone,
                          onChanged: (value) async {
                            await todoController.addTodo(
                              task.task,
                              value ?? false,
                              task.id,
                            );
                            Get.snackbar(
                              'Status Diubah',
                              'Tugas "${task.task}" telah diupdate',
                              backgroundColor: Colors.green[100],
                            );
                          },
                        ),
                        title: Text(
                          task.task,
                          style: TextStyle(
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
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
                                onPressed: () async {
                                  final confirm = await Get.dialog<bool>(
                                    AlertDialog(
                                      title: const Text('Konfirmasi Hapus'),
                                      content:
                                          Text('Hapus tugas "${task.task}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Get.back(result: false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          child: const Text('Hapus',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    todoController.deleteTask(task.id);
                                    Get.snackbar(
                                      'Dihapus',
                                      'Tugas "${task.task}" telah dihapus',
                                      backgroundColor: Colors.red[100],
                                    );
                                  }
                                },
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
      title: id.isEmpty ? "Tambah Tugas" : "Edit Tugas",
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
                  return "Tidak boleh kosong";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => addTask(id),
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addTask(String id) async {
    if (_formKey.currentState!.validate()) {
      try {
        final isUpdate = id.isNotEmpty;
        await todoController.addTodo(
          _taskController.text.trim(),
          isUpdate
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

        Get.snackbar(
          isUpdate ? 'Diupdate' : 'Ditambahkan',
          isUpdate
              ? 'Tugas berhasil diupdate'
              : 'Tugas baru berhasil ditambahkan',
          backgroundColor: Colors.green[100],
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal menyimpan: $e',
          backgroundColor: Colors.red[100],
        );
      }
    }
  }
}
