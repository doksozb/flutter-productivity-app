import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tasks/providers/task_provider.dart';

class DashboardStats {
  final int totalTasks;
  final int completedTasks;

  const DashboardStats({
    required this.totalTasks,
    required this.completedTasks,
  });

  int get pendingTasks => totalTasks - completedTasks;
  double get completionRate =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final tasksAsync = ref.watch(tasksStreamProvider);
  return tasksAsync.when(
    data: (tasks) => DashboardStats(
      totalTasks: tasks.length,
      completedTasks: tasks.where((t) => t.isCompleted).length,
    ),
    loading: () => const DashboardStats(totalTasks: 0, completedTasks: 0),
    error: (_, __) => const DashboardStats(totalTasks: 0, completedTasks: 0),
  );
});
