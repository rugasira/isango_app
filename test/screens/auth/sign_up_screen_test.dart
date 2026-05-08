import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/screens/auth/sign_up_screen.dart';

void main() {
  Widget buildTestApp({String initialRoute = AppRoutes.signUp}) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        AppRoutes.signUp: (_) => const SignUpScreen(),
        AppRoutes.login: (_) => const Scaffold(
              body: Center(child: Text('Sign In Screen')),
            ),
      },
    );
  }

  group('SignUpScreen required-field validation', () {
    testWidgets('shows errors when submitting empty form', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Scroll to and tap the submit button.
      await tester.ensureVisible(find.byKey(const Key('signUp_submitButton')));
      await tester.tap(find.byKey(const Key('signUp_submitButton')));
      await tester.pumpAndSettle();

      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('shows email validation error for invalid email',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('signUp_emailField')),
        'bad-email',
      );
      await tester.tap(find.byKey(const Key('signUp_nameField')));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });
  });

  group('SignUpScreen password validation', () {
    testWidgets('shows error for weak password', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('signUp_passwordField')),
        'short',
      );
      await tester.tap(find.byKey(const Key('signUp_nameField')));
      await tester.pumpAndSettle();

      expect(
        find.text('Minimum 8 characters with at least one number'),
        findsWidgets,
      );
    });

    testWidgets('shows error when confirm password does not match',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('signUp_passwordField')),
        'password123',
      );
      await tester.enterText(
        find.byKey(const Key('signUp_confirmPasswordField')),
        'different',
      );
      // Tap out to trigger validation.
      await tester.tap(find.byKey(const Key('signUp_nameField')));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });

  group('SignUpScreen navigation', () {
    testWidgets('navigates to /login when back button is tapped',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('signUp_backButton')));
      await tester.pumpAndSettle();

      expect(find.text('Sign In Screen'), findsOneWidget);
    });
  });
}
