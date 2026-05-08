import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_radii.dart';
import 'package:isango_app/core/theme/app_spacing.dart';
import 'package:isango_app/core/theme/app_text_styles.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isResending = false;
  bool _isVerifying = false;
  int _resendCooldown = 0; // seconds remaining before user can resend again
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 120);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendCooldown = 0);
      } else {
        if (mounted) setState(() => _resendCooldown--);
      }
    });
  }

  Future<void> _handleResend() async {
    if (_resendCooldown > 0 || _isResending) return;
    setState(() => _isResending = true);
    // TODO: Replace with actual resend email call.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isResending = false);
    _startCooldown();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.logisticsNavy,
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: AppSpacing.xs),
            const Text('Verification email resent successfully!',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  /// Simulates the user clicking the link in their email and
  /// being marked as verified — then proceeds to the Home screen.
  Future<void> _handleContinue() async {
    setState(() => _isVerifying = true);
    // TODO: Replace with real verification check (e.g. FirebaseAuth.instance.currentUser?.reload()).
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  String get _cooldownLabel {
    final mins = _resendCooldown ~/ 60;
    final secs = _resendCooldown % 60;
    return mins > 0 ? '${mins}m ${secs}s' : '${secs}s';
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
          icon: const Icon(Icons.arrow_back, color: AppColors.logisticsNavy),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
        ),
        title: Text('Verify Email', style: AppTextStyles.headline.copyWith(fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          children: [
            // ── Verification pending card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: AppColors.softBorder),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.paleSignalBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 36,
                      color: AppColors.logisticsNavy,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Verification Pending',
                    style: AppTextStyles.headline.copyWith(color: AppColors.nearBlackInk),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "We've sent a verification link to your student email. Please check your inbox to activate your account.",
                    style: AppTextStyles.bodyMuted,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Why verify card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: AppColors.softBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.verified_outlined, size: 22, color: AppColors.logisticsNavy),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why verify your email?',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        const Text(
                          'Verified students can RSVP to exclusive campus events, create their own event listings, and receive priority notifications.',
                          style: AppTextStyles.bodyMuted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── "I've verified my email" / Continue to App ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _handleContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.logisticsNavy,
                  foregroundColor: AppColors.cardWhite,
                  disabledBackgroundColor: AppColors.logisticsNavy.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.button),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
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
                          Icon(Icons.check_circle_outline, size: 18),
                          SizedBox(width: AppSpacing.xs),
                          Text("I've verified my email — Continue",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Resend button ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: (_resendCooldown > 0 || _isResending) ? null : _handleResend,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.logisticsNavy,
                  side: const BorderSide(color: AppColors.logisticsNavy),
                  disabledForegroundColor: AppColors.mutedOperationalInk,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.button),
                  ),
                ),
                child: _isResending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_outlined, size: 16),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            _resendCooldown > 0
                                ? 'Resend in $_cooldownLabel'
                                : 'Resend Verification Email',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Hint ──
            Text(
              "Can't find the email? Check your spam folder or try resending in 2 minutes.",
              style: AppTextStyles.bodyMuted.copyWith(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
