import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: AppDecorations.logoTile,
              child: const Icon(
                Icons.layers_rounded,
                color: AppColors.bgPrimary,
                size: 34,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Productivity Pro',
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Stay focused. Get things done.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 56),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.accent,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
