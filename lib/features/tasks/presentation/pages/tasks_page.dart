import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../data/models/task_model.dart';
import '../../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_sheet.dart';

enum _TaskFilter { all, active, completed }

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  _TaskFilter _selectedFilter = _TaskFilter.all;

  List<TaskModel> _applyFilter(List<TaskModel> tasks) {
    return switch (_selectedFilter) {
      _TaskFilter.all => tasks,
      _TaskFilter.active => tasks.where((t) => !t.isCompleted).toList(),
      _TaskFilter.completed => tasks.where((t) => t.isCompleted).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksStreamProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('My Tasks'),
            floating: true,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Task',
                onPressed: () => showTaskFormSheet(context),
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: SegmentedButton<_TaskFilter>(
                  segments: const [
                    ButtonSegment(
                      value: _TaskFilter.all,
                      label: Text('All'),
                      icon: Icon(Icons.list_rounded),
                    ),
                    ButtonSegment(
                      value: _TaskFilter.active,
                      label: Text('Active'),
                      icon: Icon(Icons.radio_button_unchecked_rounded),
                    ),
                    ButtonSegment(
                      value: _TaskFilter.completed,
                      label: Text('Done'),
                      icon: Icon(Icons.check_circle_rounded),
                    ),
                  ],
                  selected: {_selectedFilter},
                  onSelectionChanged: (selection) {
                    setState(() => _selectedFilter = selection.first);
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ),
          ),
        ],
        body: tasksAsync.when(
          loading: () => const AppLoadingIndicator(message: 'Loading tasks...'),
          error: (err, _) => AppErrorView(message: err.toString()),
          data: (tasks) {
            final filtered = _applyFilter(tasks);
            if (filtered.isEmpty) {
              return _buildEmptyState(context, tasks.isEmpty);
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: filtered.length,
              itemBuilder: (_, i) => TaskCard(task: filtered[i]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTaskFormSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool hasNoTasks) {
    if (hasNoTasks || _selectedFilter == _TaskFilter.all) {
      return EmptyStateView(
        icon: Icons.task_alt_rounded,
        title: 'No tasks yet',
        subtitle: 'Create your first task to get started tracking your progress.',
        actionLabel: 'Create Task',
        onAction: () => showTaskFormSheet(context),
      );
    }
    return EmptyStateView(
      icon: _selectedFilter == _TaskFilter.active
          ? Icons.radio_button_unchecked_rounded
          : Icons.check_circle_rounded,
      title: _selectedFilter == _TaskFilter.active
          ? 'No active tasks'
          : 'No completed tasks',
      subtitle: _selectedFilter == _TaskFilter.active
          ? 'All your tasks are completed. Great job!'
          : 'Complete a task to see it here.',
    );
  }
}
