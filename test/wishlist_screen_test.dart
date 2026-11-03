import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/wishlist/wishlist.dart';
import 'package:techkart/core/network/wishlist_models.dart';
import 'package:techkart/core/network/product_resolver.dart';

void main() {
  group('Wishlist Models & Resolver Tests', () {
    test('ProductResolver maps string IDs and slugs to DB IDs accurately', () {
      expect(ProductResolver.toProductId('chronos_ultra_2'), 12);
      expect(ProductResolver.toProductId('voltfast_65w_gan'), 16);
      expect(ProductResolver.toProductId('keychron_pro_wireless'), 17);
      expect(ProductResolver.toProductId('aura_fold_pro'), 19);
      expect(ProductResolver.toProductId('apex_fold_hero'), 104);
      expect(ProductResolver.toProductId('12'), 12);
      expect(ProductResolver.toProductId(16), 16);
      expect(ProductResolver.toProductId(null), 12);
    });

    test('WishlistDataModel parses backend response accurately', () {
      final json = {
        'items': [
          {
            'wishlist_item_id': 1,
            'product_id': 12,
            'seller_id': 1,
            'seller_store_name': 'TechKart Flagship Store',
            'category_name': 'Wearables',
            'title': 'Chronos Ultra 2 (49mm GPS)',
            'slug': 'chronos-ultra-2-titanium',
            'description': 'Grade 5 Titanium • 3000 Nit LTPO',
            'primary_image_url': 'asset/chronos_ultra_2.jpg',
            'price': 35499.00,
            'mrp': 39999.00,
            'stock_quantity': 3,
            'is_in_stock': true,
            'is_low_stock': true,
            'has_price_drop': true,
            'saved_at': '2026-11-03 12:00:00'
          }
        ],
        'summary': {
          'total_items': 1,
          'in_stock_count': 1,
          'price_drop_count': 1
        }
      };

      final model = WishlistDataModel.fromJson(json);
      expect(model.items.length, 1);
      expect(model.summary.totalItems, 1);
      expect(model.items.first.title, 'Chronos Ultra 2 (49mm GPS)');
      expect(model.items.first.hasPriceDrop, isTrue);
      expect(model.items.first.price, 35499.00);
      expect(model.items.first.isLowStock, isTrue);
    });
  });

  group('WishlistScreen UI & Interaction Tests', () {
    for (final width in [320.0, 360.0, 390.0, 412.0, 480.0]) {
      testWidgets('Renders WishlistScreen without overflow on width $width', (WidgetTester tester) async {
        tester.view.physicalSize = Size(width * 2.0, 844 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: WishlistScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('My Saved Items'), findsOneWidget);
        expect(find.text('Add All to Cart'), findsOneWidget);
        expect(find.text('Sort & Filter'), findsOneWidget);
        expect(find.text('Looking for more?'), findsOneWidget);

        // Verify heart icon presence
        expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
