import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/task_model.dart';
import '../../providers/task_provider.dart';
import 'task_form_sheet.dart';

class TaskCard extends ConsumerWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = task.isCompleted;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: AppDecorations.cardError,
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 22),
      ),
      child: GestureDetector(
        onTap: () => showTaskFormSheet(context, task: task),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
          decoration: AppDecorations.card,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: () {
                  ref.read(taskNotifierProvider.notifier).toggleCompletion(
                        taskId: task.id,
                        isCompleted: !done,
                      );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: done
                      ? AppDecorations.checkboxChecked
                      : AppDecorations.checkboxUnchecked,
                  child: done
                      ? const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: AppColors.bgPrimary,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: done ? AppColors.textMuted : AppColors.textPrimary,
                        decoration: done ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.textMuted,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: AppDecorations.taskTag,
                          child: Text(
                            'Task',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.accent,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _formatDate(task.createdAt),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textHint,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now   = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d     = DateTime(dt.year, dt.month, dt.day);
    final diff  = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return 'This week';
    return DateFormat('MMM d').format(dt);
  }
}
