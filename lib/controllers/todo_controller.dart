import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_getx/models/task_model.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  var isLoading = false;
  var taskList = <TaskModel>[];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTodo(String task, bool done, String id) async {
    try {
      await _firestore.collection('todos').doc(id != '' ? id : null).set({
        'task': task,
        'isDone': done,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.back(); // Close the dialog after successful save
      Get.snackbar('Success', 'Todo added successfully');
    } catch (e) {
      Get.back(); // Close the dialog even if there's an error
      Get.snackbar('Error', 'Failed to add todo: $e');
      rethrow;
    }
  }

  Future<void> getData() async {
    try {
      QuerySnapshot _taskSnap = await FirebaseFirestore.instance
          .collection("todos")
          .orderBy("task")
          .get();

      taskList.clear();

      for (var item in _taskSnap.docs) {
        taskList.add(
          TaskModel(
            id: item.id,
            task: item['task'],
            isDone: item['isDone'],
          ),
        );
      }

      isLoading = false;
      update();
    } catch (e) {
      print("Error getting data: $e");
    }
  }

  void deleteTask(String id) {
    FirebaseFirestore.instance.collection('todos').doc(id).delete();
  }
}
