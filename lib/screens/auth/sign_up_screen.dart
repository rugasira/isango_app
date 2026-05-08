import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_radii.dart';
import 'package:isango_app/core/theme/app_spacing.dart';
import 'package:isango_app/core/theme/app_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _submissionError;

  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static final _publicDomainRegex = RegExp(
    r'@(gmail|yahoo|hotmail|outlook|icloud|aol)\.',
    caseSensitive: false,
  );

  static final _passwordStrengthRegex = RegExp(r'^(?=.*\d).{8,}$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    setState(() => _submissionError = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // TODO: Replace with actual auth service call.
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
    } catch (e) {
      if (mounted) setState(() => _submissionError = 'Account creation failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mistBackground,
      appBar: AppBar(
        backgroundColor: AppColors.mistBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          key: const Key('signUp_backButton'),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.logisticsNavy,
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
        ),
        title: Text('Create Account', style: AppTextStyles.headline.copyWith(fontSize: 20)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: AppSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Join your campus community to never miss an event.',
                      style: AppTextStyles.bodyMuted,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _label('Full Name'),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    key: const Key('signUp_nameField'),
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(hintText: 'John Doe', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('University Email'),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    key: const Key('signUp_emailField'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'student@university.edu', prefixIcon: Icon(Icons.mail_outline)),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email is required';
                      if (!_emailRegex.hasMatch(v.trim())) return 'Enter a valid email address';
                      if (_publicDomainRegex.hasMatch(v.trim())) return 'Please use a valid university email address';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Password'),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    key: const Key('signUp_passwordField'),
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (!_passwordStrengthRegex.hasMatch(v)) return 'Minimum 8 characters with at least one number';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _label('Confirm Password'),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    key: const Key('signUp_confirmPasswordField'),
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Please confirm your password';
                      if (v != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  if (_submissionError != null) ...[
                    Container(
                      key: const Key('signUp_submissionError'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.criticalRed.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppRadii.input),
                      ),
                      child: Text(_submissionError!, style: AppTextStyles.bodyMuted.copyWith(color: AppColors.criticalRed)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      key: const Key('signUp_submitButton'),
                      onPressed: _isLoading ? null : _handleCreateAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.logisticsNavy,
                        foregroundColor: AppColors.cardWhite,
                        disabledBackgroundColor: AppColors.logisticsNavy.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.button)),
                      ),
                      child: _isLoading
                          ? const SizedBox(key: Key('signUp_loadingIndicator'), width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.cardWhite))
                          : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('Create Account'),
                              SizedBox(width: AppSpacing.xs),
                              Icon(Icons.arrow_forward, size: 20),
                            ]),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Center(
                    child: Text(
                      'We will send you a verification link to your email after you sign up.',
                      style: AppTextStyles.bodyMuted,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600));
}
