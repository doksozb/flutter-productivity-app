import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _signInFormKey  = GlobalKey<FormState>();
  final _signUpFormKey  = GlobalKey<FormState>();
  final _emailLoginCtrl = TextEditingController();
  final _passLoginCtrl  = TextEditingController();
  final _emailSignCtrl  = TextEditingController();
  final _passSignCtrl   = TextEditingController();
  final _confirmCtrl    = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailLoginCtrl.dispose();
    _passLoginCtrl.dispose();
    _emailSignCtrl.dispose();
    _passSignCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_signInFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(authNotifierProvider.notifier).signIn(
          _emailLoginCtrl.text,
          _passLoginCtrl.text,
        );
    if (mounted) _showError();
  }

  Future<void> _signUp() async {
    if (!_signUpFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(authNotifierProvider.notifier).signUp(
          _emailSignCtrl.text,
          _passSignCtrl.text,
        );
    if (mounted) _showError();
  }

  void _showError() {
    final authState = ref.read(authNotifierProvider);
    if (authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authState.error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 40, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 48,
                height: 48,
                decoration: AppDecorations.logoTile,
                child: const Icon(
                  Icons.layers_rounded,
                  color: AppColors.bgPrimary,
                  size: 26,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Welcome back',
                style: AppTextStyles.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sign in to your workspace',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Tabs
              Container(
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: AppRadius.md,
                ),
                padding: const EdgeInsets.all(3),
                child: TabBar(
                  controller: _tabController,
                  indicator: const BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: AppRadius.sm,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: AppTextStyles.labelMedium,
                  unselectedLabelStyle: AppTextStyles.labelMedium,
                  tabs: const [
                    Tab(text: 'Sign In'),
                    Tab(text: 'Sign Up'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Tab content (manual switch – avoids nested scroll)
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  return _tabController.index == 0
                      ? _SignInForm(
                          formKey: _signInFormKey,
                          emailCtrl: _emailLoginCtrl,
                          passCtrl: _passLoginCtrl,
                          isLoading: isLoading,
                          onSubmit: _signIn,
                        )
                      : _SignUpForm(
                          formKey: _signUpFormKey,
                          emailCtrl: _emailSignCtrl,
                          passCtrl: _passSignCtrl,
                          confirmCtrl: _confirmCtrl,
                          isLoading: isLoading,
                          onSubmit: _signUp,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sign In form ─────────────────────────────────────────────────────────────

class _SignInForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _SignInForm({
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FieldLabel('Email'),
          AuthFormField(
            controller: emailCtrl,
            label: '',
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          const _FieldLabel('Password'),
          AuthFormField(
            controller: passCtrl,
            label: '',
            hint: '••••••••',
            isPassword: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onSubmit,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.bgPrimary,
                    ),
                  )
                : const Text('Sign In'),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _Divider(),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              'Continue with Google · Apple',
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sign Up form ─────────────────────────────────────────────────────────────

class _SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final TextEditingController confirmCtrl;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _SignUpForm({
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.confirmCtrl,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FieldLabel('Email'),
          AuthFormField(
            controller: emailCtrl,
            label: '',
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          const _FieldLabel('Password'),
          AuthFormField(
            controller: passCtrl,
            label: '',
            hint: '••••••••',
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'At least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          const _FieldLabel('Confirm Password'),
          AuthFormField(
            controller: confirmCtrl,
            label: '',
            hint: '••••••••',
            isPassword: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onSubmit,
            validator: (v) {
              if (v != passCtrl.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.bgPrimary,
                    ),
                  )
                : const Text('Create Account'),
          ),
        ],
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderSubtle)),
        const SizedBox(width: AppSpacing.sm),
        Text('or', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
        const SizedBox(width: AppSpacing.sm),
        const Expanded(child: Divider(color: AppColors.borderSubtle)),
      ],
    );
  }
}
