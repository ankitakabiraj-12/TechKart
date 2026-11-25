import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/navigation/subcategory_products.dart';
import 'package:techkart/orders/return_status.dart';

void main() {
  final widths = [320.0, 360.0, 390.0, 412.0, 480.0, 600.0];

  group('SubcategoryProductsScreen Render Tests', () {
    for (final width in widths) {
      testWidgets('Renders without overflow on width $width', (tester) async {
        tester.view.physicalSize = Size(width * 2.5, 844 * 2.5);
        tester.view.devicePixelRatio = 2.5;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(
            home: SubcategoryProductsScreen(
              categoryName: 'Wearables & Watches',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    }
  });

  group('ReturnStatusScreen Render Tests', () {
    for (final width in widths) {
      testWidgets('Renders without overflow on width $width', (tester) async {
        tester.view.physicalSize = Size(width * 2.5, 844 * 2.5);
        tester.view.devicePixelRatio = 2.5;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(
            home: ReturnStatusScreen(
              caseId: 'RET-84920',
              orderId: 'TK-89421',
              estimatedRefund: 15649.00,
              pickupDateText: 'Tomorrow, Oct 28',
              productName: 'Chronos Ultra 2 GPS Edition',
              productSpecs: 'Titanium Grey • 49mm Cellular Case',
              returnReason: 'Defective / Item Not Working',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    }
  });
}
