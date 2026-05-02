import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/task_model.dart';
import '../../providers/task_provider.dart';

void showTaskFormSheet(BuildContext context, {TaskModel? task}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => TaskFormSheet(task: task),
  );
}

class TaskFormSheet extends ConsumerStatefulWidget {
  final TaskModel? task;
  const TaskFormSheet({super.key, this.task});

  @override
  ConsumerState<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends ConsumerState<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  bool _isLoading = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?.title);
    _descCtrl  = TextEditingController(text: widget.task?.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    try {
      final notifier = ref.read(taskNotifierProvider.notifier);
      if (_isEditing) {
        await notifier.updateTask(
          taskId: widget.task!.id,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
        );
      } else {
        await notifier.createTask(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: AppSpacing.md),
                width: 36,
                height: 3,
                decoration: const BoxDecoration(
                  color: AppColors.borderDefault,
                  borderRadius: AppRadius.full,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: Text(
                _isEditing ? 'Edit Task' : 'Add New Task',
                style: AppTextStyles.displaySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, AppSpacing.lg, 22, 0),
              child: TextFormField(
                controller: _titleCtrl,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Task title...',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, AppSpacing.sm, 22, 0),
              child: TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Description (optional)',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, AppSpacing.lg, 22, AppSpacing.xxl),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderSubtle),
                        foregroundColor: AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.md,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isLoading ? null : _save,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        minimumSize: Size.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.md,
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.bgPrimary,
                              ),
                            )
                          : const Text('Save Task'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
