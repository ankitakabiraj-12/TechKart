import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/ai_assistant/conversational_shopping_assistant.dart';
import 'package:techkart/navigation/main_navigation_shell.dart';
import 'package:techkart/theme/bottom_navbar.dart';

void main() {
  group('TechKart AI Responsive & Layout Tests', () {
    testWidgets('Renders properly without overflow on standard phone (390x844)', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: ConversationalShoppingAssistantScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TechKart AI'), findsOneWidget);
      expect(find.text('Smart Electronics Assistant'), findsOneWidget);
      expect(find.text('SUGGESTED QUESTIONS'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
      expect(find.text('Chronos Ultra 2 (49mm GPS)'), findsOneWidget);
      expect(find.text('View Product'), findsWidgets);
    });

    testWidgets('Renders properly without overflow on small phone (320x568)', (tester) async {
      tester.view.physicalSize = const Size(320 * 2, 568 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: ConversationalShoppingAssistantScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TechKart AI'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Renders properly on tablet viewport (768x1024)', (tester) async {
      tester.view.physicalSize = const Size(768 * 2, 1024 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: ConversationalShoppingAssistantScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TechKart AI'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Handles keyboard opening without overflow', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      tester.view.viewInsets = const FakeViewPadding(bottom: 300 * 3);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.view.resetViewInsets();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: ConversationalShoppingAssistantScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TechKart AI'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Interactive input: typing activates send button and sending adds message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConversationalShoppingAssistantScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Enter query
      await tester.enterText(find.byType(TextField), 'Show me gaming laptops');
      await tester.pump();

      // Submit via keyboard action
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      // Scroll list down to reveal latest message
      await tester.drag(find.byType(ListView), const Offset(0, -800));
      await tester.pump();

      expect(find.text('Show me gaming laptops', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Tapping suggested prompt chip sends message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConversationalShoppingAssistantScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap first prompt chip
      await tester.tap(find.text('Compare battery life'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.text('Compare battery life'), findsWidgets);
    });

    testWidgets('MainNavigationShell hides bottom navigation bar when TechKart AI is active', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Start on tab 0 (Home)
      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigationShell(initialIndex: 0),
        ),
      );
      await tester.pumpAndSettle();

      // Verify bottom navigation bar is visible on Home
      expect(find.byType(TechKartBottomNavBar), findsOneWidget);

      // Switch to TechKart AI (tab 2)
      MainNavigationShell.switchToTab(
        tester.element(find.byType(MainNavigationShell)),
        2,
      );
      await tester.pumpAndSettle();

      // Bottom navigation bar MUST be hidden on TechKart AI!
      expect(find.byType(TechKartBottomNavBar), findsNothing);
      expect(find.text('TechKart AI'), findsOneWidget);

      // Tap Back button on TechKart AI
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Bottom navigation bar MUST be restored after returning to Home!
      expect(find.byType(TechKartBottomNavBar), findsOneWidget);
    });
  });
}
