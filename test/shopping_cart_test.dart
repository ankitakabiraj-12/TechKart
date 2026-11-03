import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/wishlist/shopping_cart.dart';

void main() {
  group('ShoppingCartScreen Render Tests', () {
    for (final width in [320.0, 360.0, 390.0, 412.0]) {
      testWidgets('Renders without overflow on screen width $width', (WidgetTester tester) async {
        tester.view.physicalSize = Size(width * 2.0, 800.0 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShoppingCartScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Free Express Shipping Unlocked!'), findsOneWidget);
        expect(find.text('100% QUALIFIED'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
