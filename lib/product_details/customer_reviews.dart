import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/profile_avatar.dart';

/// TechKart Customer Reviews Screen (Chronos Ultra 2)
///
/// 100% visual fidelity reproduction of the Customer Reviews reference screen:
/// - Light airy background (#F5FAFF)
/// - Top Bar:
///   - Back button, TechKart logo mark + "Cust...", search icon, share, heart wishlist, profile avatar.
/// - Product Header Card:
///   - Image (`asset/chronos_ultra_2.jpg`), "Chronos Ultra 2", "Grade 5 Titanium • 49mm Cellular", "₹35,499.00", "✎ Review" button (#EAF5FF).
/// - Rating Summary Section:
///   - Large "4.9 / 5.0" in Domine bold serif.
///   - 5 golden review stars.
///   - "Based on 420 verified reviews", soft beige pill tag "✔ 98% recommend this product".
///   - 5-Star Breakdown Progress Bars (5★ to 1★ with counts: 370, 34, 11, 3, 2).
/// - Filters Row:
///   - "Sort: Most Relevant v" pill
///   - "✔ Verified Only" (Active dark navy #00344B pill)
///   - "With Photos (48)" pill
/// - Customer Review Cards (White rounded 20px cards with circular initials, verified buyer tag, stars, specs, bold title, Indian user context, helpful counter):
///   1. "Marcus R." -> "Madhav R."
///      - "2 days ago" • "✔ Verified Buyer"
///      - 5 Stars • "Grade 5 Titanium • 49mm"
///      - Title: "Unrivaled build quality and extreme GPS accuracy"
///      - Body: "Upgraded from the Series 7 and the difference in outdoor visibility is night and day. The 3,000 nit LTPO OLED remains crystal clear even under intense midday desert sun. Dual-frequency GPS tracked my trail with pinpoint precision. Battery easily hits 60 hours on moderate tracking."
///      - "Was this review helpful? [👍 Helpful (34)]"
///   2. "Elena L." -> "Esha L."
///      - "1 week ago" • "✔ Verified Buyer"
///      - 5 Stars • "Midnight Ocean Band"
///      - Title: "Surprisingly lightweight for aerospace titanium"
///      - Body: "I was hesitant about the 49mm case on a 155mm wrist, but the lug curvature hugs the wrist without any overhang. The tactile orange action button has zero wobble and fast-charging gets it to 80% while I get ready in the morning."
///      - "Was this review helpful? [👍 Helpful (19)]"
///   3. "David K." -> "Dev K."
///      - "2 weeks ago" • "✔ Verified Buyer"
///      - 4 Stars • "Space Black"
///      - Title: "Phenomenal hardware, companion app syncing is fast"
///      - Body: "Water resistance tested down to 25m scuba dive in Goa and the depth telemetry sensor triggered instantly with accurate water temp logs. Giving 4 stars only because the default ocean band took a couple of days to break in, but now it fits like a glove."
///      - "Was this review helpful? [👍 Helpful (8)]"
/// - Bottom Sticky Write Review Bar:
///   - "Have this product? Share your experience"
///   - Button: "✎ Write a Review" (Dark navy)
class CustomerReviewsScreen extends StatefulWidget {
  final String productId;

  const CustomerReviewsScreen({
    super.key,
    this.productId = 'chronos_ultra_2',
  });

  @override
  State<CustomerReviewsScreen> createState() => _CustomerReviewsScreenState();
}

class _CustomerReviewsScreenState extends State<CustomerReviewsScreen> {
  final Set<int> _helpfulUpvoted = {};

  final List<Map<String, dynamic>> _reviews = [
    {
      'initials': 'MR',
      'name': 'Madhav R.',
      'time': '2 days ago',
      'rating': 5,
      'specs': 'Grade 5 Titanium • 49mm',
      'title': 'Unrivaled build quality and extreme GPS accuracy',
      'body':
          'Upgraded from the Series 7 and the difference in outdoor visibility is night and day. The 3,000 nit LTPO OLED remains crystal clear even under intense midday sun. Dual-frequency GPS tracked my trail with pinpoint precision. Battery easily hits 60 hours on moderate tracking.',
      'helpful': 34,
    },
    {
      'initials': 'EL',
      'name': 'Esha L.',
      'time': '1 week ago',
      'rating': 5,
      'specs': 'Midnight Ocean Band',
      'title': 'Surprisingly lightweight for aerospace titanium',
      'body':
          'I was hesitant about the 49mm case on a 155mm wrist, but the lug curvature hugs the wrist without any overhang. The tactile orange action button has zero wobble and fast-charging gets it to 80% while I get ready in the morning.',
      'helpful': 19,
    },
    {
      'initials': 'DK',
      'name': 'Dev K.',
      'time': '2 weeks ago',
      'rating': 4,
      'specs': 'Space Black',
      'title': 'Phenomenal hardware, companion app syncing is fast',
      'body':
          'Water resistance tested down to 25m scuba dive in Goa and the depth telemetry sensor triggered instantly with accurate water temp logs. Giving 4 stars only because the default ocean band took a couple of days to break in, but now it fits like a glove.',
      'helpful': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: topPadding > 0 ? topPadding + 6 : 24),

            // ---------------------------------------------------------------
            // TOP BAR
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF00344B),
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  const SizedBox(width: 6),
                  Image.asset(
                    'asset/app_logo.png',
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'asset/app_launcher_icon.png',
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Cust...',
                    style: GoogleFonts.domine(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00344B),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF2D3748),
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 34),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: Color(0xFF2D3748),
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 34),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      size: 20,
                      color: Color(0xFF2D3748),
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 34),
                  ),
                  const SizedBox(width: 4),
                  const ProfileAvatar(size: 30),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // SCROLLABLE BODY
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Header Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00344B).withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 54,
                                height: 54,
                                color: const Color(0xFFF1F5F9),
                                child: Image.asset(
                                  'asset/chronos_ultra_2.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chronos Ultra 2',
                                    style: GoogleFonts.domine(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF00344B),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Grade 5 Titanium • 49mm Cellular',
                                    style: GoogleFonts.literata(
                                      fontSize: 11,
                                      color: const Color(0xFF718096),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '₹35,499.00',
                                    style: GoogleFonts.domine(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF00344B),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                AppNavigator.toWriteReviews(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF5FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.edit_outlined,
                                      size: 13,
                                      color: Color(0xFF00344B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Review',
                                      style: GoogleFonts.literata(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF00344B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Rating Summary Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '4.9',
                            style: GoogleFonts.domine(
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00344B),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '/ 5.0',
                            style: GoogleFonts.literata(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star_rounded,
                            size: 19,
                            color: Color(0xFF8B6B2B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        'Based on 420 verified reviews',
                        style: GoogleFonts.literata(
                          fontSize: 12,
                          color: const Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EEE4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 13,
                              color: Color(0xFF8B6B2B),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '98% recommend this product',
                              style: GoogleFonts.literata(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8B6B2B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 5-Star Breakdown Bars
                      _buildRatingBar(star: 5, fillRatio: 0.88, count: '370'),
                      _buildRatingBar(star: 4, fillRatio: 0.12, count: '34'),
                      _buildRatingBar(star: 3, fillRatio: 0.05, count: '11'),
                      _buildRatingBar(star: 2, fillRatio: 0.02, count: '3'),
                      _buildRatingBar(star: 1, fillRatio: 0.01, count: '2'),

                      const SizedBox(height: 20),

                      // Filter Chips Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF5FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Sort: Most Relevant',
                                  style: GoogleFonts.literata(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF00344B),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 15,
                                  color: Color(0xFF00344B),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00344B),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_rounded,
                                    size: 13, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  'Verified Only',
                                  style: GoogleFonts.literata(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF5FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'With Photos (48)',
                              style: GoogleFonts.literata(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF00344B),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Reviews List
                      ...List.generate(_reviews.length, (index) {
                        final r = _reviews[index];
                        final isUpvoted = _helpfulUpvoted.contains(index);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00344B)
                                      .withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD9ECFE),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          r['initials'] as String,
                                          style: GoogleFonts.literata(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00344B),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r['name'] as String,
                                          style: GoogleFonts.domine(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00344B),
                                          ),
                                        ),
                                        Text(
                                          r['time'] as String,
                                          style: GoogleFonts.literata(
                                            fontSize: 10,
                                            color: const Color(0xFF718096),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF5FF),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.verified_user_outlined,
                                            size: 11,
                                            color: Color(0xFF00344B),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Verified Buyer',
                                            style: GoogleFonts.literata(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF00344B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Row(
                                      children: List.generate(
                                        5,
                                        (starIndex) => Icon(
                                          starIndex < (r['rating'] as int)
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          size: 15,
                                          color: const Color(0xFF8B6B2B),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '• ${r['specs']}',
                                      style: GoogleFonts.literata(
                                        fontSize: 10.5,
                                        color: const Color(0xFF718096),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                Text(
                                  r['title'] as String,
                                  style: GoogleFonts.domine(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF00344B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r['body'] as String,
                                  style: GoogleFonts.literata(
                                    fontSize: 12,
                                    color: const Color(0xFF4A5568),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    Text(
                                      'Was this review helpful?',
                                      style: GoogleFonts.literata(
                                        fontSize: 10.5,
                                        color: const Color(0xFF718096),
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        setState(() {
                                          if (isUpvoted) {
                                            _helpfulUpvoted.remove(index);
                                          } else {
                                            _helpfulUpvoted.add(index);
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF5FF),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.thumb_up_alt_outlined,
                                              size: 13,
                                              color: Color(0xFF00344B),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Helpful (${(r['helpful'] as int) + (isUpvoted ? 1 : 0)})',
                                              style: GoogleFonts.literata(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF00344B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.flag_outlined,
                                      size: 14,
                                      color: Color(0xFF718096),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // BOTTOM STICKY BAR: WRITE A REVIEW
            // ---------------------------------------------------------------
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, bottomPadding > 0 ? bottomPadding + 8 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Have this product?',
                        style: GoogleFonts.literata(
                          fontSize: 11,
                          color: const Color(0xFF718096),
                        ),
                      ),
                      Text(
                        'Share your experience',
                        style: GoogleFonts.domine(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00344B),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        AppNavigator.toWriteReviews(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00344B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.rate_review_outlined, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Write a Review',
                            style: GoogleFonts.literata(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar({
    required int star,
    required double fillRatio,
    required String count,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            child: Text(
              '$star',
              style: GoogleFonts.literata(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A5568),
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, size: 12, color: Color(0xFF718096)),
          const SizedBox(width: 8),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 6,
                color: const Color(0xFFEAF5FF),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: fillRatio,
                  child: Container(
                    color: const Color(0xFF00344B),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          SizedBox(
            width: 24,
            child: Text(
              count,
              textAlign: TextAlign.end,
              style: GoogleFonts.literata(
                fontSize: 10,
                color: const Color(0xFF718096),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
