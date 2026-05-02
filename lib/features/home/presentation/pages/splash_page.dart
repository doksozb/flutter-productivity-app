import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 52,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Productivity Pro',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Stay focused. Get things done.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.75),
                  ),
            ),
            const SizedBox(height: 56),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: colorScheme.onPrimary,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
