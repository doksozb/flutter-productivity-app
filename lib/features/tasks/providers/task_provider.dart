import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(FirebaseFirestore.instance);
});

final tasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(taskRepositoryProvider).watchTasks(user.uid);
});

class TaskNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  String get _userId {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) throw Exception('User not authenticated.');
    return user.uid;
  }

  Future<void> createTask({
    required String title,
    required String description,
  }) async {
    await ref.read(taskRepositoryProvider).createTask(
          userId: _userId,
          title: title,
          description: description,
        );
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
  }) async {
    await ref.read(taskRepositoryProvider).updateTask(
          userId: _userId,
          taskId: taskId,
          title: title,
          description: description,
        );
  }

  Future<void> toggleCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {
    await ref.read(taskRepositoryProvider).toggleCompletion(
          userId: _userId,
          taskId: taskId,
          isCompleted: isCompleted,
        );
  }

  Future<void> deleteTask(String taskId) async {
    await ref.read(taskRepositoryProvider).deleteTask(
          userId: _userId,
          taskId: taskId,
        );
  }
}

final taskNotifierProvider = AsyncNotifierProvider<TaskNotifier, void>(
  TaskNotifier.new,
);
