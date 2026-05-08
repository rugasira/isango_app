import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_radii.dart';
import 'package:isango_app/core/theme/app_spacing.dart';
import 'package:isango_app/core/theme/app_text_styles.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _submissionError;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Future auth hook — replace with real Firebase sign-in when ready.
  Future<void> _handleSignIn() async {
    setState(() => _submissionError = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      // TODO: Replace with actual auth service call.
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (mounted) {
        setState(() => _submissionError = 'Sign-in failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset will be available soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mistBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.page,
              vertical: AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.logisticsNavy.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Isango wordmark ──
                      Text(
                        'Isango',
                        style: AppTextStyles.display.copyWith(
                          color: AppColors.logisticsNavy,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Welcome back!',
                        style: AppTextStyles.headline.copyWith(
                          color: AppColors.nearBlackInk,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Sign in to access your personalized campus events feed.',
                        style: AppTextStyles.bodyMuted,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Email ──
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _label('Email Address'),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        key: const Key('signIn_emailField'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'student@domain',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!_emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid university email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // ── Password ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label('Password'),
                          GestureDetector(
                            key: const Key('signIn_forgotPassword'),
                            onTap: _handleForgotPassword,
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.commandBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        key: const Key('signIn_passwordField'),
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Submission error ──
                      if (_submissionError != null) ...[
                        Container(
                          key: const Key('signIn_submissionError'),
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.criticalRed.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppRadii.input),
                          ),
                          child: Text(
                            _submissionError!,
                            style: AppTextStyles.bodyMuted
                                .copyWith(color: AppColors.criticalRed),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],

                      // ── Sign In CTA ──
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          key: const Key('signIn_submitButton'),
                          onPressed: _isLoading ? null : _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.logisticsNavy,
                            foregroundColor: AppColors.cardWhite,
                            disabledBackgroundColor:
                                AppColors.logisticsNavy.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadii.button),
                            ),
                            textStyle: AppTextStyles.title.copyWith(
                              color: AppColors.cardWhite,
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  key: Key('signIn_loadingIndicator'),
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.cardWhite,
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Sign Up link ──
                      GestureDetector(
                        key: const Key('signIn_signUpLink'),
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.signUp,
                        ),
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an account?  ",
                            style: AppTextStyles.bodyMuted,
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: AppTextStyles.bodyMuted.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.logisticsNavy,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
