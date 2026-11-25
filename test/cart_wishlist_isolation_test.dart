import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/wishlist/wishlist.dart';
import 'package:techkart/wishlist/shopping_cart.dart';
import 'package:techkart/app_routes/app_navigator.dart';
import 'package:techkart/core/network/cart_models.dart';
import 'package:techkart/core/network/wishlist_models.dart';

void main() {
  group('Cart & Wishlist Isolation and Navigation Tests', () {
    test('Cart and Wishlist data models are separate and isolated', () {
      final cartJson = {
        'items': [
          {
            'cart_item_id': 101,
            'product_id': 12,
            'seller_id': 1,
            'seller_store_name': 'TechKart Flagship Store',
            'title': 'Chronos Ultra 2',
            'slug': 'chronos-ultra-2',
            'price': 35499.00,
            'mrp': 39999.00,
            'quantity': 2,
            'item_total': 70998.00,
            'stock_quantity': 10,
            'is_in_stock': true,
          }
        ],
        'summary': {
          'total_quantity': 2,
          'item_count': 1,
          'subtotal': 70998.00,
          'discount': 0.0,
          'tax': 0.0,
          'shipping_fee': 0.0,
          'final_total': 70998.00,
        }
      };

      final wishlistJson = {
        'items': [
          {
            'wishlist_item_id': 201,
            'product_id': 16,
            'seller_id': 1,
            'seller_store_name': 'TechKart Flagship Store',
            'title': 'VoltFast 65W GaN',
            'slug': 'voltfast-65w-gan',
            'price': 7399.00,
            'stock_quantity': 5,
            'is_in_stock': true,
            'saved_at': '2026-11-04 10:00:00',
          }
        ],
        'summary': {
          'total_items': 1,
          'in_stock_count': 1,
          'price_drop_count': 0,
        }
      };

      final cartModel = CartDataModel.fromJson(cartJson);
      final wishlistModel = WishlistDataModel.fromJson(wishlistJson);

      expect(cartModel.items.length, 1);
      expect(cartModel.items.first.productId, 12);
      expect(cartModel.summary.totalQuantity, 2);

      expect(wishlistModel.items.length, 1);
      expect(wishlistModel.items.first.productId, 16);
      expect(wishlistModel.summary.totalItems, 1);
    });

    testWidgets('WishlistScreen displays Wishlist in header and does not render Cart title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WishlistScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('My Saved Items'), findsOneWidget);
    });

    testWidgets('ShoppingCartScreen displays empty state when cart has 0 items', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCartScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Cart'), findsWidgets);
      expect(find.text('Your shopping cart is empty'), findsOneWidget);
      expect(find.text('Start Shopping'), findsOneWidget);
    });

    testWidgets('AppNavigator toCart navigates to ShoppingCartScreen', (WidgetTester tester) async {
      final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navKey,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppNavigator.toCart(context),
                child: const Text('Open Cart'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Cart'));
      await tester.pumpAndSettle();

      expect(find.byType(ShoppingCartScreen), findsOneWidget);
      expect(find.byType(WishlistScreen), findsNothing);
      expect(find.text('Cart'), findsWidgets);
    });

    testWidgets('AppNavigator toWishlist navigates to WishlistScreen', (WidgetTester tester) async {
      final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navKey,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppNavigator.toWishlist(context),
                child: const Text('Open Wishlist'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Wishlist'));
      await tester.pumpAndSettle();

      expect(find.byType(WishlistScreen), findsOneWidget);
      expect(find.byType(ShoppingCartScreen), findsNothing);
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('My Saved Items'), findsOneWidget);
    });
  });
}
