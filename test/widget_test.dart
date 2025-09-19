// Teste básico para o aplicativo Tractian Seller

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Simple test that just verifies Flutter is working
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Tractian Seller'),
          ),
        ),
      ),
    );

    // Verify that the test widget is displayed
    expect(find.text('Tractian Seller'), findsOneWidget);
  });
}
