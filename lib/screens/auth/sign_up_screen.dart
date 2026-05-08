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
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _submissionError;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final _passwordStrengthRegex = RegExp(r'^(?=.*\d).{8,}$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Future auth hook — replace with real Firebase account creation when ready.
  Future<void> _handleCreateAccount() async {
    setState(() => _submissionError = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual auth service call.
      await Future.delayed(const Duration(seconds: 2));

      // Hand off to verify-email flow (placeholder).
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => _submissionError =
              'Account creation failed. Please try again.',
        );
      }
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
        leading: IconButton(
          key: const Key('signUp_backButton'),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.logisticsNavy,
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.page,
              vertical: AppSpacing.lg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  border: Border.all(color: AppColors.softBorder),
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      const Text('Sign Up', style: AppTextStyles.display),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Create your student logistics account',
                        style: AppTextStyles.bodyMuted,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Full Name
                      _buildFieldLabel('FULL NAME'),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        key: const Key('signUp_nameField'),
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'John Doe',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // University Email
                      _buildFieldLabel('UNIVERSITY EMAIL'),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        key: const Key('signUp_emailField'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'j.doe@university.edu',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!_emailRegex.hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Student ID
                      _buildFieldLabel('STUDENT ID'),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        key: const Key('signUp_studentIdField'),
                        controller: _studentIdController,
                        decoration: const InputDecoration(
                          hintText: 'ID-12345678',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Student ID is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Password
                      _buildFieldLabel('PASSWORD'),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        key: const Key('signUp_passwordField'),
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
                          if (!_passwordStrengthRegex.hasMatch(value)) {
                            return 'Minimum 8 characters with at least one number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      const Text(
                        'Minimum 8 characters with at least one number.',
                        style: AppTextStyles.label,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Confirm Password
                      _buildFieldLabel('CONFIRM PASSWORD'),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        key: const Key('signUp_confirmPasswordField'),
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Submission error
                      if (_submissionError != null) ...[
                        Container(
                          key: const Key('signUp_submissionError'),
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color:
                                AppColors.criticalRed.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(
                              AppRadii.input,
                            ),
                          ),
                          child: Text(
                            _submissionError!,
                            style: AppTextStyles.bodyMuted.copyWith(
                              color: AppColors.criticalRed,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],

                      // Primary CTA
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          key: const Key('signUp_submitButton'),
                          onPressed:
                              _isLoading ? null : _handleCreateAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.safetyOrange,
                            foregroundColor: AppColors.cardWhite,
                            disabledBackgroundColor:
                                AppColors.safetyOrange.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadii.button,
                              ),
                            ),
                            textStyle: AppTextStyles.title.copyWith(
                              color: AppColors.cardWhite,
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  key: Key('signUp_loadingIndicator'),
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.cardWhite,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Create Account'),
                                    SizedBox(width: AppSpacing.xs),
                                    Icon(Icons.arrow_forward, size: 20),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Sign In link
                      Center(
                        child: GestureDetector(
                          key: const Key('signUp_signInLink'),
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',
                              style: AppTextStyles.bodyMuted,
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: AppTextStyles.bodyMuted.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.nearBlackInk,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Legal footer
                      const Divider(color: AppColors.softBorder),
                      const SizedBox(height: AppSpacing.md),
                      Text.rich(
                        TextSpan(
                          text: 'By signing up, you agree to Isango\'s ',
                          style: AppTextStyles.label,
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: AppTextStyles.label.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: AppTextStyles.label.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' regarding campus delivery security and student data usage.',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.nearBlackInk,
      ),
    );
  }
}
