import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/catalog_models.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';
import '../theme/app_theme.dart';

/// TechKart Categories Screen – Complete 45 Categories Integration
///
/// Premium image-based category cards fetched from the shared Core PHP backend API.
/// Preserves exact 45 main category names, slugs, and display order (1-45).
/// Features full state handling (loading shimmer/spinner, error retry, empty search, pull-to-refresh).
class CategoriesScreen extends StatefulWidget {
  final int initialTabIndex;
  final bool showBottomNav;
  final ValueChanged<int>? onNavTabSelected;
  final ValueChanged<bool>? onSearchStateChanged;

  const CategoriesScreen({
    super.key,
    this.initialTabIndex = 1,
    this.showBottomNav = true,
    this.onNavTabSelected,
    this.onSearchStateChanged,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _filterController = TextEditingController();
  final FocusNode _filterFocusNode = FocusNode();
  final ApiClient _apiClient = ApiClient();

  int _selectedPillIndex = 0;
  final List<String> _pills = ['All Categories', 'Audio', 'Wearables', 'Power', 'Computing', 'Smart Home'];

  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  // Curated subtitles and highlights for categories to give them a premium TechKart aesthetic
  static const Map<String, String> _subtitles = {
    'mobiles-smartphones': 'Flagship smartphones, 5G devices & foldables',
    'laptops-notebooks': 'Ultrabooks, workstation laptops & gaming rigs',
    'computers-desktops': 'Prebuilt rigs, mini PCs & creator workstations',
    'monitors-displays': '4K OLED displays, ultra-wides & high-refresh panels',
    'computer-accessories': 'Mechanical keyboards, precision mice & ergonomic gear',
    'audio-headphones': 'Studio over-ear ANC, wireless earbuds & audiophile IEMs',
    'wearables': 'Titanium GPS smartwatches, fitness bands & biometric rings',
    'tv-home-entertainment': '4K QLED smart TVs, Dolby Atmos bars & streaming hubs',
    'gaming': 'Next-gen consoles, handhelds, VR headsets & controllers',
    'cameras-photography': 'Mirrorless cameras, prime lenses & creator gimbal kits',
    'drones': '4K camera quadcopters, FPV drones & thermal optics',
    'chargers-power': 'GaN fast wall chargers, multi-port hubs & MagSafe docks',
    'power-banks-batteries': 'High-density battery packs & portable power stations',
    'electrical-power-equipment': 'Smart surge protectors, inverters & UPS power backups',
    'networking': 'Wi-Fi 7 mesh systems, gigabit routers & PoE switches',
    'smart-home': 'Smart displays, climate control hubs & Matter automation',
    'security-surveillance': 'AI security cams, video doorbells & smart deadbolts',
    'home-appliances': 'Robotic vacuums, air purifiers & smart dehumidifiers',
    'kitchen-appliances': 'Precision air fryers, espresso machines & smart blenders',
    'automotive-electronics': 'Dash cams, wireless CarPlay adapters & EV chargers',
    'printers-office-electronics': 'Laser duplex printers, document scanners & shredders',
    'storage-memory': 'PCIe Gen5 NVMe SSDs, portable hard drives & DDR5 RAM',
    'electronics-tools-repair': 'Soldering stations, precision bit kits & heat guns',
    'electronic-components': 'Microcontrollers, breadboards, SMD sensors & ICs',
    'robotics-development': 'Robotic arms, servos, motor shields & dev boards',
    'scientific-measurement-electronics': 'Digital oscilloscopes, bench multimeters & logic probes',
    'solar-renewable-energy': 'Monocrystalline solar panels, MPPTs & solar generators',
    'lighting': 'RGB ambient lighting, smart LED bulbs & studio ring lights',
    '3d-printing-fabrication': 'High-speed Core-XY 3D printers, resin vats & filaments',
    'vr-ar-metaverse': 'Standalone 6DoF headsets, pancake optics & spatial controllers',
    'gps-navigation': 'Handheld GPS navigators, marine telematics & vehicle trackers',
    'communication-equipment': 'Long-range walkie-talkies, satellite beacons & intercoms',
    'industrial-electronics': 'Industrial PLCs, DIN-rail relays & automation modules',
    'medical-healthcare-electronics': 'Digital pulse oximeters, smart BP monitors & ECG bands',
    'office-business-technology': 'POS terminals, barcode scanners & conference speakerphones',
    'professional-audio-studio': 'XLR condenser mics, studio reference monitors & audio interfaces',
    'musical-electronics': 'Digital synthesizers, MIDI keyboards & guitar effect pedals',
    'servers-data-center': 'Rackmount server chassis, NAS storage arrays & SAS controllers',
    'cables-connectors-adapters': 'Thunderbolt 4 cables, braided HDMI 2.1 & OTG adapters',
    'refurbished-used-electronics': 'Certified pre-owned gadgets with 1-year brand warranty',
    'smart-devices-iot': 'Zigbee smart plugs, presence sensors & Thread border routers',
    'electronic-accessories': 'Cable organizers, laptop sleeves & aluminum desk stands',
    'gaming-accessories': 'Desk pads, ultra-light mouse skates & headset stands',
    'photo-video-accessories': 'Carbon fiber tripods, studio backdrops & camera cages',
    'other-electronics': 'Specialized hardware devices & experimental electronics',
    'tablets-ereaders': 'Flagship iPads, Android tablets & Kindle e-readers',
    'wearable-fitness-electronics': 'Titanium GPS smartwatches, fitness bands & biometric rings',
    'cooling-air-treatment': 'Inverter split ACs, air purifiers & BLDC fans',
    'washing-cleaning-appliances': 'Front load washers, smart dishwashers & robot vacuums',
    'refrigerators-freezers': 'Multi-door refrigerators, convertible freezers & mini bars',
    'personal-care-electronics': 'Precision trimmers, sonic toothbrushes & ionic hair dryers',
    'electronic-toys-gadgets': 'Programmable robotics, STEM kits & RC quadcopters',
    'streaming-content-creation': 'Creator ring lights, capture cards & streaming decks',
    'automotive-accessories': 'Dash cams, tire pressure monitors & wireless CarPlay kits',
  };

  static const Map<String, String> _tags = {
    'mobiles-smartphones': 'Flagship',
    'computer-accessories': 'New Gen',
    'audio-headphones': 'Studio Sound',
    'wearables': 'Titanium',
    'chargers-power': 'GaN III',
    'storage-memory': 'High-Speed',
    'gaming': 'Next-Gen',
    'drones': '4K HDR',
    'refurbished-used-electronics': 'Certified',
  };

  @override
  void initState() {
    super.initState();
    _filterFocusNode.addListener(_onSearchFocusChanged);
    _fetchCategories();
  }

  void _onSearchFocusChanged() {
    final isSearching = _filterFocusNode.hasFocus || _searchQuery.isNotEmpty;
    widget.onSearchStateChanged?.call(isSearching);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _filterFocusNode.removeListener(_onSearchFocusChanged);
    _filterFocusNode.dispose();
    _filterController.dispose();
    _apiClient.close();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _apiClient.getCategories();
      if (!mounted) return;

      if (res.success && res.data != null) {
        setState(() {
          _categories = res.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = res.message.isNotEmpty ? res.message : 'Failed to load categories';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Network connection error. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _onCategoryTapped(CategoryModel category) {
    HapticFeedback.lightImpact();
    AppNavigator.toSubcategoryProducts(context, category: category);
  }

  List<CategoryModel> _getFilteredCategories() {
    return _categories.where((cat) {
      final nameMatches = _searchQuery.isEmpty ||
          cat.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cat.slug.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!nameMatches) return false;

      if (_selectedPillIndex == 0) return true;
      final selectedPill = _pills[_selectedPillIndex].toLowerCase();

      if (selectedPill == 'audio') {
        return cat.slug.contains('audio') || cat.slug.contains('musical');
      } else if (selectedPill == 'wearables') {
        return cat.slug.contains('wearables') || cat.slug.contains('medical');
      } else if (selectedPill == 'power') {
        return cat.slug.contains('power') || cat.slug.contains('charger') || cat.slug.contains('solar') || cat.slug.contains('battery');
      } else if (selectedPill == 'computing') {
        return cat.slug.contains('computer') || cat.slug.contains('laptop') || cat.slug.contains('server') || cat.slug.contains('storage');
      } else if (selectedPill == 'smart home') {
        return cat.slug.contains('smart') || cat.slug.contains('security') || cat.slug.contains('appliances') || cat.slug.contains('lighting');
      }
      return true;
    }).toList();
  }

  Widget _buildCategoryImage(CategoryModel category) {
    final assetPath = 'asset/categories/${category.slug}.jpg';
    return Image.asset(
      assetPath,
      cacheWidth: 350,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to general icon
        return Container(
          color: const Color(0xFFF0F5FD),
          child: const Center(
            child: Icon(
              Icons.devices_other_rounded,
              size: 28,
              color: Color(0xFF000000),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final filteredList = _getFilteredCategories();

    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: topPadding > 0 ? topPadding + 8 : 28),

            // ---------------------------------------------------------------
            // TOP BAR: Back + Explore Categories Title + Notification Bell + Avatar
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else if (widget.onNavTabSelected != null) {
                        widget.onNavTabSelected!(0);
                      } else {
                        AppNavigator.toHome(context);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppTheme.primaryText,
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Explore Categories',
                      style: GoogleFonts.literata(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Bell with notification dot
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          AppNavigator.toNotifications(context);
                        },
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          size: 23,
                          color: Color(0xFF000000),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                      ),
                      Positioned(
                        top: 6,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDC2626),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),

                  // User Avatar
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      AppNavigator.toCustomerProfileHub(context);
                    },
                    child: const ProfileAvatar(
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // SEARCH FILTER BAR
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppTheme.winterMist,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.borders,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 19,
                      color: AppTheme.secondaryText,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _filterController,
                        focusNode: _filterFocusNode,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                          final isSearching =
                              _filterFocusNode.hasFocus ||
                                  _searchQuery.isNotEmpty;
                          widget.onSearchStateChanged?.call(isSearching);
                        },
                        style: GoogleFonts.literata(
                          fontSize: 13.5,
                          color: AppTheme.primaryText,
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          fillColor: Colors.transparent,
                          hintText:
                              'Search across all 45 engineering categories...',
                          hintStyle: GoogleFonts.literata(
                            fontSize: 13,
                            color: AppTheme.secondaryText,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _filterController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          final isSearching = _filterFocusNode.hasFocus;
                          widget.onSearchStateChanged?.call(isSearching);
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          size: 18,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // HORIZONTAL CATEGORY PILL FILTER RAIL
            // ---------------------------------------------------------------
            SizedBox(
              height: 36,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _pills.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedPillIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedPillIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.evergreen
                              : AppTheme.winterMist,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppTheme.evergreen : AppTheme.borders,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _pills[index],
                            style: GoogleFonts.literata(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? AppTheme.pureWhite : AppTheme.primaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // MAIN BODY: LOADING, ERROR, EMPTY OR 45 CATEGORY CARDS
            // ---------------------------------------------------------------
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF000000),
                backgroundColor: const Color(0xFFF8FAFC),
                onRefresh: _fetchCategories,
                child: _buildBody(filteredList),
              ),
            ),

            // ---------------------------------------------------------------
            // BOTTOM NAVIGATION BAR
            // ---------------------------------------------------------------
            if (widget.showBottomNav &&
                !_filterFocusNode.hasFocus &&
                _searchQuery.isEmpty)
              TechKartBottomNavBar(
                currentIndex: 1, // Categories tab active
                onTabSelected: (index) {
                  if (widget.onNavTabSelected != null) {
                    widget.onNavTabSelected!(index);
                  } else {
                    if (index == 0) {
                      AppNavigator.toHome(context);
                    } else if (index == 2) {
                      AppNavigator.toConversationalShoppingAssistant(context);
                    } else if (index == 3) {
                      AppNavigator.toCart(context);
                    } else if (index == 4) {
                      AppNavigator.toCustomerProfileHub(context);
                    }
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<CategoryModel> filteredList) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.evergreen,
          strokeWidth: 2.5,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppTheme.evergreen,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.literata(
                  fontSize: 14,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchCategories,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.evergreen,
                  foregroundColor: AppTheme.pureWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Color(0xFF000000),
            ),
            const SizedBox(height: 12),
            Text(
              'No categories match "$_searchQuery"',
              style: GoogleFonts.literata(
                fontSize: 14,
                color: const Color(0xFF000000),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // List of Category Cards
            ...filteredList.map((cat) {
              final subtitle = _subtitles[cat.slug] ?? 'Verified Hardware & Components';
              final tag = _tags[cat.slug];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _onCategoryTapped(cat),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.borders,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Category Image Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 64,
                            height: 64,
                            color: AppTheme.winterMist,
                            child: _buildCategoryImage(cat),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Title, Subtitle, Order Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      cat.name,
                                      style: GoogleFonts.literata(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primaryText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (tag != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 2.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.snowySage.withValues(alpha: 0.25),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        tag,
                                        style: GoogleFonts.literata(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.evergreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                subtitle,
                                style: GoogleFonts.literata(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.secondaryText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Hardware Sector #${cat.id.toString().padLeft(2, '0')}',
                                style: GoogleFonts.literata(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Forward Navigation Arrow Button
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.winterMist,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.borders,
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 15,
                              color: AppTheme.evergreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 10),

            // -----------------------------------------------------
            // BOTTOM ECOSYSTEM SETS CARD (Preserved)
            // -----------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF142D4E),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: 0.12,
                      child: const Icon(
                        Icons.hub_rounded,
                        size: 100,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ECOSYSTEM SETS',
                          style: GoogleFonts.literata(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFF8FAFC),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Desk & Sound Bundles',
                        style: GoogleFonts.literata(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Curated pairings calibrated for\nlatency-free workflows.',
                        style: GoogleFonts.literata(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            AppNavigator.toSubcategoryProducts(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF142D4E),
                            foregroundColor: const Color(0xFFF8FAFC),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Explore Kits',
                                style: GoogleFonts.literata(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFF8FAFC),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: Color(0xFFF8FAFC),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
