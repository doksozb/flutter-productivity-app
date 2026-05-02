import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';

class AuthRouterNotifier extends ChangeNotifier {
  final Ref _ref;
  late final ProviderSubscription _subscription;

  AuthRouterNotifier(this._ref) {
    _subscription = _ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  String? redirect(GoRouterState state) {
    final authAsync = _ref.read(authStateProvider);

    if (authAsync.isLoading) {
      return state.matchedLocation == '/splash' ? null : '/splash';
    }

    final isLoggedIn = authAsync.valueOrNull != null;
    final location = state.matchedLocation;
    final isAuthPage = location == '/login';
    final isSplash = location == '/splash';

    if (!isLoggedIn && !isAuthPage) return '/login';
    if (isLoggedIn && (isAuthPage || isSplash)) return '/dashboard';

    return null;
  }
}
