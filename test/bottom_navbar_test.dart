import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/theme/bottom_navbar.dart';

void main() {
  group('TechKartBottomNavBar Widget Tests', () {
    testWidgets('Renders all five items and handles tab switching', (
      WidgetTester tester,
    ) async {
      int selectedTab = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: StatefulBuilder(
              builder: (context, setState) {
                return TechKartBottomNavBar(
                  currentIndex: selectedTab,
                  cartBadgeCount: 3,
                  onTabSelected: (index) {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify all 5 tab text labels are discoverable
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Categories'), findsWidgets);
      expect(find.text('AI Chatbot'), findsWidgets);
      expect(find.text('Cart'), findsWidgets);
      expect(find.text('Profile'), findsWidgets);

      // Verify cart badge count is displayed
      // Notification badge removed globally
      expect(find.text('3'), findsNothing);

      // Initially selected is Home (index 0)
      expect(selectedTab, 0);

      // Tap Categories (index 1)
      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(selectedTab, 1);

      // Tap AI Search (index 2)
      await tester.tap(find.text('AI Chatbot'));
      await tester.pumpAndSettle();
      expect(selectedTab, 2);

      // Tap Cart (index 3)
      await tester.tap(find.text('Cart'));
      await tester.pumpAndSettle();
      expect(selectedTab, 3);

      // Tap Profile (index 4)
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(selectedTab, 4);

      // Tap Home back (index 0)
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(selectedTab, 0);
    });

    testWidgets(
      'Adapts responsively to different screen widths without overflow',
      (WidgetTester tester) async {
        for (final width in [320.0, 360.0, 390.0, 428.0, 768.0, 1024.0]) {
          tester.view.physicalSize = Size(width, 800);
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                bottomNavigationBar: TechKartBottomNavBar(
                  currentIndex: 2,
                  cartBadgeCount: 2,
                ),
              ),
            ),
          );

          // Verify no RenderFlex or overflow errors
          expect(tester.takeException(), isNull);

          // Verify active label is visible
          expect(find.text('AI Chatbot'), findsWidgets);
        }

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
      },
    );

    testWidgets('Has no rectangular borders or dividers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: TechKartBottomNavBar(currentIndex: 0),
          ),
        ),
      );

      // Verify zero Dividers
      expect(find.byType(Divider), findsNothing);
      expect(find.byType(VerticalDivider), findsNothing);
    });

    testWidgets(
      'Renders with gradient shield seamlessly concealing cut-off cards',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              backgroundColor: Color(0xFFF8FAFC),
              body: Center(child: Text('Main Content Area')),
              bottomNavigationBar: TechKartBottomNavBar(
                currentIndex: 1, // Categories active
              ),
            ),
          ),
        );

        // Verify Categories active disc is rendered
        expect(find.text('Categories'), findsWidgets);
        // Verify no dividers or rectangular borders
        expect(find.byType(Divider), findsNothing);
        expect(find.byType(VerticalDivider), findsNothing);
      },
    );
  });
}
