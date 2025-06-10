import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTodo(String task, bool done) async {
    try {
      await _firestore.collection('todos').add({
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
}
