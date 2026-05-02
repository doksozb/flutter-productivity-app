import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../tasks/presentation/widgets/task_form_sheet.dart';
import '../../../tasks/providers/task_provider.dart';
import '../../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user      = ref.watch(authStateProvider).valueOrNull;
    final stats     = ref.watch(dashboardStatsProvider);
    final tasksAsync= ref.watch(tasksStreamProvider);
    final email     = user?.email ?? '';
    final displayName = email.split('@').first;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
        slivers: [
          _buildHeader(context, displayName),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Overview'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStatsGrid(stats),
                  const SizedBox(height: AppSpacing.md),
                  _buildProgressCard(stats),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionLabel('Quick Actions'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildQuickActions(context),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionLabel('Recent Activity'),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),
          ),
          _buildActivitySection(context, tasksAsync),
          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  SliverToBoxAdapter _buildHeader(BuildContext context, String displayName) {
    final now = DateTime.now();
    final greeting = _greeting(now.hour);
    final dateStr  = DateFormat('EEEE, d MMMM yyyy').format(now);

    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.bgPrimary,
        padding: const EdgeInsets.fromLTRB(22, AppSpacing.lg, 22, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting.toUpperCase(),
              style: AppTextStyles.overline,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              displayName.isEmpty ? 'Welcome' : displayName,
              style: AppTextStyles.displayMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              dateStr,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Stats 2×2 grid ───────────────────────────────────────────────────────────

  Widget _buildStatsGrid(DashboardStats stats) {
    final pct = '${(stats.completionRate * 100).round()}%';
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _StatCard(
                icon: Icons.grid_view_rounded,
                value: '${stats.totalTasks}',
                label: 'Total Tasks',
                accent: false,
              ),
              const SizedBox(height: AppSpacing.sm),
              _StatCard(
                icon: Icons.access_time_rounded,
                value: '${stats.pendingTasks}',
                label: 'Pending',
                accent: false,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            children: [
              _StatCard(
                icon: Icons.check_rounded,
                value: '${stats.completedTasks}',
                label: 'Completed',
                accent: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              _StatCard(
                icon: Icons.trending_up_rounded,
                value: pct,
                label: 'Done Rate',
                accent: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Progress bar card ────────────────────────────────────────────────────────

  Widget _buildProgressCard(DashboardStats stats) {
    final pct = (stats.completionRate * 100).round();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.card,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly Progress', style: AppTextStyles.labelMedium),
              Text(
                '$pct%',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.full,
            child: LinearProgressIndicator(
              value: stats.completionRate,
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick Actions ────────────────────────────────────────────────────────────

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add_rounded,
            iconColor: AppColors.accent,
            iconBg: AppColors.accentSurface,
            label: 'New Task',
            onTap: () => showTaskFormSheet(context),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.format_quote_rounded,
            iconColor: AppColors.purple,
            iconBg: AppColors.purpleDim,
            label: 'Quotes',
            onTap: () => context.go('/quotes'),
          ),
        ),
      ],
    );
  }

  // ─── Recent Activity ──────────────────────────────────────────────────────────

  Widget _buildActivitySection(
    BuildContext context,
    AsyncValue<List<TaskModel>> tasksAsync,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: tasksAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: AppLoadingIndicator(),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (tasks) {
            if (tasks.isEmpty) {
              return const _EmptyActivity(
                message: 'No activity yet. Create a task to get started.',
              );
            }
            final recent = tasks.take(3).toList();
            return Container(
              decoration: AppDecorations.card,
              child: Column(
                children: recent.asMap().entries.map((entry) {
                  final i    = entry.key;
                  final task = entry.value;
                  final isLast = i == recent.length - 1;
                  return _ActivityItem(task: task, isLast: isLast);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Text(text.toUpperCase(), style: AppTextStyles.overline);
  }

  String _greeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool accent;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: accent ? AppDecorations.cardAccent : AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: accent ? AppDecorations.iconTileAccent : AppDecorations.iconTile,
            child: Icon(
              icon,
              color: accent ? AppColors.accent : AppColors.textSecondary,
              size: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: accent ? AppTextStyles.statNumberAccent : AppTextStyles.statNumber,
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}

// ─── Quick action button ──────────────────────────────────────────────────────

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppDecorations.quickAction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: AppRadius.sm,
              ),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: AppTextStyles.labelMedium),
          ],
        ),
      ),
    );
  }
}

// ─── Activity item ────────────────────────────────────────────────────────────

class _ActivityItem extends StatelessWidget {
  final TaskModel task;
  final bool isLast;

  const _ActivityItem({required this.task, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final dot  = task.isCompleted ? AppColors.accent : AppColors.purple;
    final verb = task.isCompleted ? 'Completed' : 'Added';
    final time = _formatDate(task.createdAt);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.borderSubtle),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '$verb "${task.title}"',
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            time,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
          ),
        ],
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
    return DateFormat('MMM d').format(dt);
  }
}

// ─── Empty activity ───────────────────────────────────────────────────────────

class _EmptyActivity extends StatelessWidget {
  final String message;
  const _EmptyActivity({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: AppSpacing.xl),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: AppDecorations.iconTile,
            child: const Icon(
              Icons.history_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(message, style: AppTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }
}
