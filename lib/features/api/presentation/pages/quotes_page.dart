import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../data/models/quote_model.dart';
import '../../providers/quote_provider.dart';

class QuotesPage extends ConsumerWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotesAsync = ref.watch(quotesProvider);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DAILY INSPIRATION', style: AppTextStyles.overline),
                const SizedBox(height: AppSpacing.xs),
                Text('Motivate', style: AppTextStyles.displayMedium),
              ],
            ),
          ),

          // ─── Content ──────────────────────────────────────────────────────
          Expanded(
            child: quotesAsync.when(
              loading: () => const _SkeletonList(),
              error: (err, _) => AppErrorView(
                message: 'Could not load quotes. Check your connection.',
                onRetry: () => ref.invalidate(quotesProvider),
              ),
              data: (quotes) => _QuotesList(
                quotes: quotes,
                onRefresh: () async => ref.invalidate(quotesProvider),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

// ─── Quotes list ──────────────────────────────────────────────────────────────

class _QuotesList extends StatelessWidget {
  final List<QuoteModel> quotes;
  final Future<void> Function() onRefresh;

  const _QuotesList({required this.quotes, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.accent,
      backgroundColor: AppColors.bgSurface,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
        itemCount: quotes.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) return _RefreshButton(onTap: onRefresh);
          return _QuoteCard(quote: quotes[i - 1]);
        },
      ),
    );
  }
}

// ─── Refresh button ───────────────────────────────────────────────────────────

class _RefreshButton extends StatelessWidget {
  final Future<void> Function() onTap;
  const _RefreshButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: AppDecorations.card,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.refresh_rounded, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 7),
            Text(
              'Refresh Quotes',
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quote card ───────────────────────────────────────────────────────────────

class _QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(quote.author);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(18),
      decoration: AppDecorations.card,
      child: Stack(
        children: [
          // Decorative large quote mark
          Positioned(
            top: -8,
            left: 0,
            child: Text(
              '"',
              style: AppTextStyles.displayLarge.copyWith(
                fontSize: 72,
                color: AppColors.borderSubtle,
                height: 1,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote text
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: Text(
                  quote.text,
                  style: AppTextStyles.bodySmall.copyWith(height: 1.65),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Author row
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.bgElevated,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.accent,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote.author.isEmpty ? 'Unknown' : quote.author,
                          style: AppTextStyles.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Productivity Collection',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textHint,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// ─── Loading skeleton ─────────────────────────────────────────────────────────

class _SkeletonList extends StatefulWidget {
  const _SkeletonList();

  @override
  State<_SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<_SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.9).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
        itemCount: 4,
        itemBuilder: (_, __) => Opacity(
          opacity: _anim.value,
          child: Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: AppDecorations.card,
          ),
        ),
      ),
    );
  }
}
