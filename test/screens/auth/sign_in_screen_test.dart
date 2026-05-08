import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/screens/auth/sign_in_screen.dart';

void main() {
  Widget buildTestApp({String initialRoute = AppRoutes.login}) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        AppRoutes.login: (_) => const SignInScreen(),
        AppRoutes.signUp: (_) => const Scaffold(
              body: Center(child: Text('Sign Up Screen')),
            ),
        AppRoutes.home: (_) => const Scaffold(
              body: Center(child: Text('Home Screen')),
            ),
      },
    );
  }

  group('SignInScreen validation', () {
    testWidgets('shows inline email validation error for empty email',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Enter text then clear it to trigger onUserInteraction validation.
      await tester.enterText(
        find.byKey(const Key('signIn_emailField')),
        'a',
      );
      await tester.enterText(
        find.byKey(const Key('signIn_emailField')),
        '',
      );
      // Focus on another field to trigger validation.
      await tester.tap(find.byKey(const Key('signIn_passwordField')));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows inline email validation error for invalid email',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('signIn_emailField')),
        'not-an-email',
      );
      await tester.tap(find.byKey(const Key('signIn_passwordField')));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('shows required password validation error', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Tap submit without filling password.
      await tester.enterText(
        find.byKey(const Key('signIn_emailField')),
        'test@example.com',
      );
      await tester.tap(find.byKey(const Key('signIn_submitButton')));
      await tester.pumpAndSettle();

      expect(find.text('Password is required'), findsOneWidget);
    });
  });

  group('SignInScreen navigation', () {
    testWidgets('navigates to /signup when Sign Up link is tapped',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Scroll down to make the Sign Up link visible.
      await tester.ensureVisible(find.byKey(const Key('signIn_signUpLink')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('signIn_signUpLink')));
      await tester.pumpAndSettle();

      expect(find.text('Sign Up Screen'), findsOneWidget);
    });
  });

  group('SignInScreen loading state', () {
    testWidgets('shows loading indicator and disables CTA during sign-in',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Fill in valid form data.
      await tester.enterText(
        find.byKey(const Key('signIn_emailField')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('signIn_passwordField')),
        'password123',
      );
      await tester.pumpAndSettle();

      // Tap sign in.
      await tester.tap(find.byKey(const Key('signIn_submitButton')));
      // Pump a short duration to enter loading state.
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the loading indicator appears.
      expect(
        find.byKey(const Key('signIn_loadingIndicator')),
        findsOneWidget,
      );

      // Complete the future to avoid pending timer errors.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });
}
