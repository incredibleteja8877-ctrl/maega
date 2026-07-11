// Widget test for LoginScreen: verifies it renders with the expected
// fields. Login itself now goes through Firebase Auth, so exercising the
// full sign-in flow belongs in an integration test against a real (or
// emulated) Firebase project rather than a plain widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:maega_app/screens/login_screen.dart';

void main() {
  testWidgets('shows the login screen with expected fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
  });
}
