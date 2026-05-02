import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../providers/task_provider.dart';

void showTaskFormSheet(BuildContext context, {TaskModel? task}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _isLoading = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController =
        TextEditingController(text: widget.task?.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        );
      } else {
        await notifier.createTask(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Edit Task' : 'New Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                autofocus: !_isEditing,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'What needs to be done?',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Title is required';
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: TextFormField(
                controller: _descriptionController,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                onFieldSubmitted: (_) => _save(),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Add details (optional)',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: FilledButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isEditing ? 'Save Changes' : 'Create Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
