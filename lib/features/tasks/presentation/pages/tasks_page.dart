import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../data/models/task_model.dart';
import '../../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_sheet.dart';

enum _TaskFilter { all, pending, done }

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  _TaskFilter _filter = _TaskFilter.all;

  List<TaskModel> _apply(List<TaskModel> tasks) => switch (_filter) {
        _TaskFilter.all     => tasks,
        _TaskFilter.pending => tasks.where((t) => !t.isCompleted).toList(),
        _TaskFilter.done    => tasks.where((t) => t.isCompleted).toList(),
      };

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ──────────────────────────────────────────────────────
          Container(
            color: AppColors.bgPrimary,
            padding: const EdgeInsets.fromLTRB(22, AppSpacing.lg, 22, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MY TASKS', style: AppTextStyles.overline),
                      const SizedBox(height: AppSpacing.xs),
                      tasksAsync.when(
                        loading: () => const SizedBox(height: 28),
                        error:   (_, __) => const SizedBox(height: 28),
                        data: (tasks) => Text(
                          '${tasks.length} Task${tasks.length == 1 ? '' : 's'}',
                          style: AppTextStyles.displayMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => showTaskFormSheet(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: AppRadius.md,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.bgPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Filter chips ─────────────────────────────────────────────────
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              children: [
                _FilterChip(
                  label: 'All',
                  active: _filter == _TaskFilter.all,
                  onTap: () => setState(() => _filter = _TaskFilter.all),
                ),
                const SizedBox(width: 7),
                _FilterChip(
                  label: 'Pending',
                  active: _filter == _TaskFilter.pending,
                  onTap: () => setState(() => _filter = _TaskFilter.pending),
                ),
                const SizedBox(width: 7),
                _FilterChip(
                  label: 'Done',
                  active: _filter == _TaskFilter.done,
                  onTap: () => setState(() => _filter = _TaskFilter.done),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // ─── Task list ────────────────────────────────────────────────────
          Expanded(
            child: tasksAsync.when(
              loading: () => const AppLoadingIndicator(message: 'Loading tasks…'),
              error:   (err, _) => AppErrorView(message: err.toString()),
              data: (tasks) {
                final filtered = _apply(tasks);
                if (filtered.isEmpty) {
                  return _EmptyState(
                    filter: _filter,
                    onAdd: () => showTaskFormSheet(context),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => TaskCard(task: filtered[i]),
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}

// ─── Filter chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: active
            ? AppDecorations.chipActive
            : BoxDecoration(
                border: Border.all(color: AppColors.borderDefault, width: 1),
                borderRadius: AppRadius.full,
              ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: active ? AppColors.bgPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final _TaskFilter filter;
  final VoidCallback onAdd;

  const _EmptyState({required this.filter, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final isAll = filter == _TaskFilter.all;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: AppDecorations.card,
              child: const Icon(
                Icons.checklist_rounded,
                size: 24,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              isAll ? 'No tasks yet' : 'Nothing here',
              style: AppTextStyles.displaySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isAll
                  ? 'Tap + to create your first task'
                  : 'No tasks match this filter',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (isAll) ...[
              const SizedBox(height: AppSpacing.xxl),
              FilledButton(
                onPressed: onAdd,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(140, 44),
                ),
                child: const Text('Create Task'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
