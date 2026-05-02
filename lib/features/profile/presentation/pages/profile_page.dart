import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user    = ref.watch(authStateProvider).valueOrNull;
    final email   = user?.email ?? '';
    final name    = email.split('@').first;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final initials = name.length > 1
        ? '${name[0]}${name[1]}'.toUpperCase()
        : initial;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
        children: [
          // ─── Header ────────────────────────────────────────────────────
          Container(
            color: AppColors.bgPrimary,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, AppSpacing.lg, 22, AppSpacing.xl),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 72,
                  height: 72,
                  decoration: AppDecorations.avatar,
                  child: Center(
                    child: Text(
                      initials,
                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(name, style: AppTextStyles.displaySmall),
                const SizedBox(height: 3),
                Text(email, style: AppTextStyles.labelSmall),
              ],
            ),
          ),

          // ─── Menu ──────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, AppSpacing.lg, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account group
                  _MenuGroup(
                    label: 'Account',
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Edit Profile',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        label: 'Change Password',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Preferences group
                  _MenuGroup(
                    label: 'Preferences',
                    items: [
                      _MenuItem(
                        icon: Icons.dark_mode_outlined,
                        label: 'Dark Mode',
                        trailing: _Toggle(value: true, onTap: () {}),
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // App group
                  _MenuGroup(
                    label: 'App',
                    items: [
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        label: 'About',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Logout
                  GestureDetector(
                    onTap: () =>
                        ref.read(authNotifierProvider.notifier).signOut(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: AppDecorations.cardError,
                      child: Center(
                        child: Text(
                          'Sign Out',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

// ─── Menu group ───────────────────────────────────────────────────────────────

class _MenuGroup extends StatelessWidget {
  final String label;
  final List<_MenuItem> items;

  const _MenuGroup({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.overline),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: AppDecorations.card,
          child: Column(
            children: items.asMap().entries.map((e) {
              final i    = e.key;
              final item = e.value;
              final isLast = i == items.length - 1;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MenuItemTile(item: item),
                  if (!isLast)
                    const Divider(height: 0, indent: 14, endIndent: 0),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });
}

class _MenuItemTile extends StatelessWidget {
  final _MenuItem item;

  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: AppDecorations.iconTile,
              child: Icon(item.icon, size: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(item.label, style: AppTextStyles.labelMedium),
            ),
            item.trailing ??
                Text(
                  '›',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// ─── Toggle switch ────────────────────────────────────────────────────────────

class _Toggle extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;

  const _Toggle({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 20,
        decoration: BoxDecoration(
          color: value ? AppColors.accent : AppColors.bgElevated,
          borderRadius: AppRadius.full,
        ),
        padding: const EdgeInsets.all(3),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: AppColors.bgPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
