import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../data/models/quote_model.dart';
import '../../providers/quote_provider.dart';

class QuotesPage extends ConsumerWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotesAsync = ref.watch(quotesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('Inspiration'),
            floating: true,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Refresh',
                onPressed: () => ref.invalidate(quotesProvider),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
        body: quotesAsync.when(
          loading: () => const AppLoadingIndicator(message: 'Fetching quotes...'),
          error: (err, _) => AppErrorView(
            message: 'Could not load quotes. Check your connection.',
            onRetry: () => ref.invalidate(quotesProvider),
          ),
          data: (quotes) => _QuotesList(quotes: quotes),
        ),
      ),
    );
  }
}

class _QuotesList extends StatelessWidget {
  final List<QuoteModel> quotes;

  const _QuotesList({required this.quotes});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Invalidate from parent; this just triggers pull gesture feedback
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: quotes.length,
        itemBuilder: (_, i) => _QuoteCard(quote: quotes[i]),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final QuoteModel quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final accentColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];
    final accentColor = accentColors[quote.text.length % accentColors.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: accentColor,
                      size: 28,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      quote.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 2,
                          color: accentColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            quote.author.isEmpty ? 'Unknown' : quote.author,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
