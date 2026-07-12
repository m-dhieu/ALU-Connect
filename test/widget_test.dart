// Basic Flutter smoke test for the ALU Connect app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aluconnect/main.dart';

void main() {
  testWidgets('App launches and shows onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ALUConnectApp()));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
