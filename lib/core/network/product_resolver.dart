class ProductResolver {
  ProductResolver._();

  /// Map client-side UI product keys / slugs / IDs to database product integers
  static const Map<String, int> _idMap = {
    // Flagship Chronos
    'chronos_ultra_2': 12,
    'chronos-ultra-2': 12,
    'chronos-ultra-2-titanium': 12,
    'chronos_ultra_x': 12,
    '12': 12,

    // Fast GaN & Chargers
    'voltfast_65w_gan': 16,
    'voltfast-65w-gan-dual-usb-c': 16,
    'carousel_fast_gan_charger': 16,
    '16': 16,
    'volta_65w_gan': 103,
    'volta-65w-gan': 103,
    'hypercharge_gan': 106,
    'volta_dual_dock': 112,

    // Keyboards
    'keychron_pro_wireless': 17,
    'pro-ergo-mechanical-keyboard': 17,
    'keychron_pro_keyboard': 17,
    '17': 17,

    // Foldables & Phones
    'aura_fold_pro': 19,
    'aura-fold-pro-5g-flagship': 19,
    'apex_fold_hero': 104,
    'apex-fold': 104,
    'sug_lumina_fold': 102,
    '19': 19,

    // Audio & Wearables
    'aura_studio_anc': 101,
    'apex_anc_wireless': 21,
    'omni_dock_station': 105,
    'desk_bundle_clean': 105,
    'soundpulse_pro': 107,
    'aero_pro_anc_4': 108,
    'chronos_light': 109,
    'apex_buds_pro': 110,
    'aura_watch_studio': 111,
    '2': 2,
    '3': 3,
  };

  /// Convert string identifier into valid backend database product_id
  static int toProductId(dynamic identifier) {
    if (identifier == null) return 12;
    if (identifier is int && identifier > 0) return identifier;
    final str = identifier.toString().trim().toLowerCase();
    final parsed = int.tryParse(str);
    if (parsed != null && parsed > 0) return parsed;
    return _idMap[str] ?? 12;
  }
}
