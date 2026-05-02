import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> _tasksRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks');
  }

  Stream<List<TaskModel>> watchTasks(String userId) {
    return _tasksRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> createTask({
    required String userId,
    required String title,
    required String description,
  }) async {
    await _tasksRef(userId).add({
      'title': title,
      'description': description,
      'isCompleted': false,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updateTask({
    required String userId,
    required String taskId,
    required String title,
    required String description,
  }) async {
    await _tasksRef(userId).doc(taskId).update({
      'title': title,
      'description': description,
    });
  }

  Future<void> toggleCompletion({
    required String userId,
    required String taskId,
    required bool isCompleted,
  }) async {
    await _tasksRef(userId).doc(taskId).update({'isCompleted': isCompleted});
  }

  Future<void> deleteTask({
    required String userId,
    required String taskId,
  }) async {
    await _tasksRef(userId).doc(taskId).delete();
  }
}
