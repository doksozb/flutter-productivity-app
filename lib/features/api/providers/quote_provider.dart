import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/quote_model.dart';
import '../data/repositories/quote_repository.dart';

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  return QuoteRepository();
});

final quotesProvider = FutureProvider<List<QuoteModel>>((ref) {
  return ref.watch(quoteRepositoryProvider).fetchQuotes();
});
