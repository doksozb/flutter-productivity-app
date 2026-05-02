import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../../../tasks/presentation/widgets/task_form_sheet.dart';
import '../../../tasks/providers/task_provider.dart';
import '../../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final stats = ref.watch(dashboardStatsProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final email = user?.email ?? '';
    final initial = (email.split('@').first.isNotEmpty)
        ? email.split('@').first[0].toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context, ref, colorScheme, email, initial),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(context, colorScheme, stats),
                  const SizedBox(height: 16),
                  _buildProgressCard(context, colorScheme, stats),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          _buildRecentTasksSection(context, ref, colorScheme, tasksAsync),
          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  SliverAppBar _buildSliverHeader(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    String email,
    String initial,
  ) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    final displayName = email.split('@').first;
    final dateStr = DateFormat('EEEE, MMMM d').format(now);

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xFF3B0E8A),
      foregroundColor: Colors.white,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Productivity Pro',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 22),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => ref.read(authNotifierProvider.notifier).signOut(),
            child: Tooltip(
              message: 'Sign Out',
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _HeaderBackground(
          greeting: greeting,
          displayName: displayName,
          dateStr: dateStr,
        ),
      ),
    );
  }

  // ─── Stats ───────────────────────────────────────────────────────────────────

  Widget _buildStatsRow(
    BuildContext context,
    ColorScheme colorScheme,
    DashboardStats stats,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.layers_rounded,
            label: 'Total',
            value: stats.totalTasks.toString(),
            iconColor: colorScheme.primary,
            iconBackground: colorScheme.primaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_rounded,
            label: 'Done',
            value: stats.completedTasks.toString(),
            iconColor: const Color(0xFF15803D),
            iconBackground: const Color(0xFFDCFCE7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.pending_rounded,
            label: 'Pending',
            value: stats.pendingTasks.toString(),
            iconColor: colorScheme.error,
            iconBackground: colorScheme.errorContainer,
          ),
        ),
      ],
    );
  }

  // ─── Progress ────────────────────────────────────────────────────────────────

  Widget _buildProgressCard(
    BuildContext context,
    ColorScheme colorScheme,
    DashboardStats stats,
  ) {
    final percent = (stats.completionRate * 100).round();
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: stats.completionRate,
                  strokeWidth: 9,
                  strokeCap: StrokeCap.round,
                  backgroundColor:
                      colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$percent%',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                            height: 1,
                          ),
                    ),
                    Text(
                      'done',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Progress',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  stats.totalTasks == 0
                      ? 'Create your first task to begin tracking progress.'
                      : '${stats.completedTasks} of ${stats.totalTasks} tasks completed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                ),
                if (stats.totalTasks > 0) ...[
                  const SizedBox(height: 14),
                  _MotivationChip(
                    rate: stats.completionRate,
                    colorScheme: colorScheme,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Recent tasks ─────────────────────────────────────────────────────────────

  Widget _buildRecentTasksSection(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    AsyncValue<List<TaskModel>> tasksAsync,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                ),
                TextButton(
                  onPressed: () => context.go('/tasks'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('See all'),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            tasksAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: AppLoadingIndicator(),
              ),
              error: (_, __) => const SizedBox.shrink(),
              data: (tasks) {
                if (tasks.isEmpty) {
                  return _EmptyCTA(
                    onTap: () => showTaskFormSheet(context),
                    colorScheme: colorScheme,
                  );
                }
                return Column(
                  children: tasks.take(5).map((t) => TaskCard(task: t)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

// ─── Header background widget ─────────────────────────────────────────────────

class _HeaderBackground extends StatelessWidget {
  final String greeting;
  final String displayName;
  final String dateStr;

  const _HeaderBackground({
    required this.greeting,
    required this.displayName,
    required this.dateStr,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2D0A78),
                Color(0xFF5B21B6),
                Color(0xFF7C3AED),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Decorative circle – top-right
        Positioned(
          top: -40,
          right: -30,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
        ),
        // Decorative circle – bottom-left
        Positioned(
          bottom: -20,
          left: -40,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
        ),
        // Decorative circle – mid-right
        Positioned(
          top: 70,
          right: 60,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
        ),
        // Text content
        Positioned(
          left: 20,
          right: 20,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: Colors.white60,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color iconBackground;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  height: 1,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

// ─── Motivation chip ──────────────────────────────────────────────────────────

class _MotivationChip extends StatelessWidget {
  final double rate;
  final ColorScheme colorScheme;

  const _MotivationChip({required this.rate, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (rate) {
      0.0 => ("Let's get started!", Icons.rocket_launch_rounded),
      < 0.34 => ('Good start, keep going!', Icons.local_fire_department_rounded),
      < 0.67 => ("You're halfway there!", Icons.trending_up_rounded),
      < 1.0 => ('Almost done, push through!', Icons.flash_on_rounded),
      _ => ('All tasks complete!', Icons.celebration_rounded),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: colorScheme.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state CTA ─────────────────────────────────────────────────────────

class _EmptyCTA extends StatelessWidget {
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _EmptyCTA({required this.onTap, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4527A0), Color(0xFF6750A4), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6750A4).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Start your journey',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create your first task and start tracking your daily progress.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Create a task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
