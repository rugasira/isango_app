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
  bool _rememberDevice = false;
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

      // Simulate a successful sign-in navigating to home.
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
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
      const SnackBar(
        content: Text('Password reset will be available soon.'),
      ),
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
              vertical: AppSpacing.lg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Isango wordmark ──
                  _buildWordmark(),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Card ──
                  Container(
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
                          const Text('Sign In', style: AppTextStyles.display),
                          const SizedBox(height: AppSpacing.xs),
                          const Text(
                            'Please enter your credentials to\naccess the Isango platform.',
                            style: AppTextStyles.bodyMuted,
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Email field
                          _buildFieldLabel('EMAIL OR ID'),
                          const SizedBox(height: AppSpacing.xs),
                          TextFormField(
                            key: const Key('signIn_emailField'),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'name@company.com',
                              prefixIcon: Icon(Icons.person_outline),
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

                          // Password label row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildFieldLabel('PASSWORD'),
                              GestureDetector(
                                key: const Key('signIn_forgotPassword'),
                                onTap: _handleForgotPassword,
                                child: Text(
                                  'Forgot Password?',
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.commandBlue,
                                    fontWeight: FontWeight.w600,
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
                          const SizedBox(height: AppSpacing.md),

                          // Remember device
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  key: const Key('signIn_rememberCheckbox'),
                                  value: _rememberDevice,
                                  onChanged: (v) => setState(
                                    () => _rememberDevice = v ?? false,
                                  ),
                                  activeColor: AppColors.logisticsNavy,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              const Text(
                                'Remember this device',
                                style: AppTextStyles.bodyMuted,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Submission error
                          if (_submissionError != null) ...[
                            Container(
                              key: const Key('signIn_submissionError'),
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.criticalRed.withValues(alpha: 0.08),
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
                              key: const Key('signIn_submitButton'),
                              onPressed: _isLoading ? null : _handleSignIn,
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
                                      key: Key('signIn_loadingIndicator'),
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors.cardWhite,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Sign In'),
                                        SizedBox(width: AppSpacing.xs),
                                        Icon(Icons.arrow_forward, size: 20),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Sign Up link ──
                  const Divider(color: AppColors.softBorder),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: GestureDetector(
                      key: const Key('signIn_signUpLink'),
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.signUp,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: 'New to the platform? ',
                          style: AppTextStyles.bodyMuted,
                          children: [
                            TextSpan(
                              text: 'Sign Up',
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
                  const SizedBox(height: AppSpacing.xl),

                  // ── Footer ──
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordmark() {
    return Row(
      children: [
        Icon(
          Icons.local_shipping_outlined,
          size: 28,
          color: AppColors.logisticsNavy,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'Isango',
          style: AppTextStyles.title.copyWith(
            color: AppColors.logisticsNavy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          '© 2024 ISANGO GLOBAL LOGISTICS. ALL RIGHTS RESERVED.',
          style: AppTextStyles.label.copyWith(fontSize: 10),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PRIVACY\nPOLICY',
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
            Text(
              'TERMS OF\nSERVICE',
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'SUPPORT',
              style: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
