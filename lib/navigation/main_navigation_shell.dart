import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/bottom_navbar.dart';
import 'home.dart';
import 'categories.dart';
import '../ai_assistant/conversational_shopping_assistant.dart';
import '../wishlist/shopping_cart.dart';
import '../profile_settings/customer_profile_hub.dart';

/// TechKart Main Navigation Shell (SCR-04 / ECOSYSTEM HUB)
///
/// Top-level shell hosting the 5 primary tabs inside an IndexedStack:
/// 0: Home (SCR-04-A HomeScreen)
/// 1: Categories (SCR-05 CategoriesScreen)
/// 2: TechKart AI (ConversationalShoppingAssistantScreen)
/// 3: Cart (ShoppingCartScreen from shopping_cart.dart)
/// 4: Profile (SCR-22 CustomerProfileHubScreen)
///
/// Features the unified, strictly height-bounded 5-tab TechKartBottomNavBar.
/// Implements lazy tab activation so other tabs don't block Home startup.
class MainNavigationShell extends StatefulWidget {
  /// Initial tab index to display (0: Home, 1: Categories, 2: AI Search, 3: Cart, 4: Profile).
  final int initialIndex;

  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
  });

  /// Allows child screens or global navigators to cleanly switch tabs in the root shell
  static bool switchToTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationShellState>();
    if (state != null) {
      state.switchToTab(index);
      return true;
    }
    return false;
  }

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;
  final int _cartItemCount = 2;
  bool _isCategoriesSearching = false;
  late final Set<int> _activatedTabs;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _activatedTabs = {widget.initialIndex};
  }

  @override
  void didUpdateWidget(covariant MainNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex;
      _activatedTabs.add(widget.initialIndex);
    }
  }

  void switchToTab(int index) {
    _onTabSelected(index);
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    HapticFeedback.selectionClick();
    setState(() {
      _currentIndex = index;
      _activatedTabs.add(index);
      _isCategoriesSearching = false;
    });
  }

  void _onCategoriesSearchChanged(bool isSearching) {
    if (_isCategoriesSearching != isSearching) {
      setState(() {
        _isCategoriesSearching = isSearching;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _activatedTabs.contains(0)
                ? HomeScreen(
                    showBottomNav: false,
                    onNavTabSelected: _onTabSelected,
                  )
                : const SizedBox.shrink(),
            _activatedTabs.contains(1)
                ? CategoriesScreen(
                    showBottomNav: false,
                    onNavTabSelected: _onTabSelected,
                    onSearchStateChanged: _onCategoriesSearchChanged,
                  )
                : const SizedBox.shrink(),
            _activatedTabs.contains(2)
                ? ConversationalShoppingAssistantScreen(
                    showBottomNav: false,
                    onNavTabSelected: _onTabSelected,
                    onBack: () => _onTabSelected(0),
                  )
                : const SizedBox.shrink(),
            _activatedTabs.contains(3)
                ? ShoppingCartScreen(
                    showBottomNav: false,
                    onNavTabSelected: _onTabSelected,
                    onBack: () => _onTabSelected(0),
                  )
                : const SizedBox.shrink(),
            _activatedTabs.contains(4)
                ? CustomerProfileHubScreen(
                    showBottomNav: false,
                    onNavTabSelected: _onTabSelected,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: (_currentIndex == 2 ||
              _isCategoriesSearching ||
              MediaQuery.of(context).viewInsets.bottom > 0)
          ? null
          : TechKartBottomNavBar(
              currentIndex: _currentIndex,
              onTabSelected: _onTabSelected,
              cartBadgeCount: _cartItemCount,
            ),
    );
  }
}
