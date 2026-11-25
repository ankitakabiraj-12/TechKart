import 'dart:convert';
import 'package:flutter/material.dart';
import 'network/api_client.dart';
import 'network/api_exception.dart';
import 'network/token_storage.dart';

/// Centralized Session & User Identity Manager for TechKart Customer App
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final TokenStorage _tokenStorage = TokenStorage();
  final ApiClient _apiClient = ApiClient();

  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? _profileStats;
  bool _initialized = false;

  /// ValueNotifier to broadcast user profile changes (name, gender, avatar) across screens
  final ValueNotifier<Map<String, dynamic>?> currentUserNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);

  Map<String, dynamic>? get currentUser => _currentUser;
  Map<String, dynamic>? get profileStats => _profileStats;

  String? get userName => (_currentUser?['full_name'] as String?)?.trim();

  String? get userEmail => (_currentUser?['email'] as String?)?.trim();

  String? get userPhone => (_currentUser?['phone'] as String?)?.trim();

  String? get userGender {
    final g = (_currentUser?['gender'] as String?)?.toLowerCase().trim();
    if (g == 'male' || g == 'female' || g == 'other') return g;
    return null;
  }

  /// Check whether an authenticated customer is currently signed in.
  bool get isAuthenticated => _currentUser != null && _currentUser!.isNotEmpty;

  /// Returns the matching male/female asset path based on gender.
  /// - Guests use 'assets/avatar.png' (or 'asset/avatar.png').
  /// - Authenticated users use 'assets/female_avatar.png' or 'assets/male_avatar.png'
  ///   from their explicitly saved profile gender ('female' / 'male').
  /// - Unknown or unsaved gender defaults to 'assets/avatar.png'.
  String get avatarAssetPath {
    if (!isAuthenticated) {
      return 'assets/avatar.png';
    }

    final gender = userGender;
    if (gender == 'female') {
      return 'assets/female_avatar.png';
    } else if (gender == 'male') {
      return 'assets/male_avatar.png';
    }

    // If user has custom uploaded avatar URL
    final avatarUrl = _currentUser?['avatar_url'] as String?;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return avatarUrl;
    }

    return 'assets/avatar.png';
  }

  /// Initialize and load cached user identity
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final raw = await _tokenStorage.getUserData();
      if (raw != null && raw.isNotEmpty) {
        _currentUser = jsonDecode(raw) as Map<String, dynamic>;
        currentUserNotifier.value = _currentUser;
      }
    } catch (e) {
      debugPrint('[SessionManager] Init error: $e');
    } finally {
      _initialized = true;
    }
  }

  /// Quick check for local cached session without waiting for a network round-trip.
  /// Used for instant app startup transitions.
  Future<bool> hasCachedSession() async {
    final token = await _tokenStorage.getToken();
    if (token == null || token.trim().isEmpty) {
      return false;
    }
    final cachedUser = await _tokenStorage.getUserData();
    if (cachedUser != null && cachedUser.isNotEmpty) {
      try {
        _currentUser = jsonDecode(cachedUser) as Map<String, dynamic>;
        currentUserNotifier.value = _currentUser;
        return true;
      } catch (_) {}
    }
    return false;
  }

  /// Validate current session against MySQL backend.
  /// Returns true if token is valid and session is active.
  /// Refreshes user profile (including gender) from database.
  Future<bool> validateSession({Duration timeout = const Duration(seconds: 4)}) async {
    final token = await _tokenStorage.getToken();
    if (token == null || token.trim().isEmpty) {
      await clearSession();
      return false;
    }

    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/customer/auth/profile',
        requiresAuth: true,
        connectTimeout: timeout,
        responseTimeout: timeout,
        fromJsonData: (data) =>
            data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (response.success && response.data != null) {
        final userData = response.data!['user'];
        if (userData != null && userData is Map<String, dynamic>) {
          await updateUser(userData);
          return true;
        }
      }
      // If unauthorized (401) or inactive (403), invalidate
      await clearSession();
      return false;
    } catch (e) {
      debugPrint('[SessionManager] Session validation check failed: $e');
      // If token exists and network failed, keep existing session if cached user exists
      final cachedUser = await _tokenStorage.getUserData();
      if (cachedUser != null && cachedUser.isNotEmpty) {
        _currentUser = jsonDecode(cachedUser) as Map<String, dynamic>;
        currentUserNotifier.value = _currentUser;
        return true;
      }
      return false;
    }
  }

  /// Save session after login / registration
  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> userData,
    String? refreshToken,
  }) async {
    await _tokenStorage.saveToken(token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _tokenStorage.saveRefreshToken(refreshToken);
    }
    await updateUser(userData);
  }

  /// Update wishlist count directly in cached profileStats
  void updateWishlistCount(int count) {
    if (_profileStats != null) {
      _profileStats!['wishlist_count'] = count;
    } else {
      _profileStats = {'wishlist_count': count};
    }
  }

  /// Update user in memory and persistent secure storage
  Future<void> updateUser(Map<String, dynamic> userData) async {
    _currentUser = Map<String, dynamic>.from(userData);
    currentUserNotifier.value = _currentUser;
    await _tokenStorage.saveUserData(jsonEncode(_currentUser));
  }

  /// Fetch the latest profile and persisted account stats from the backend.
  Future<Map<String, dynamic>?> refreshProfile() async {
    final token = await _tokenStorage.getToken();
    if (token == null || token.trim().isEmpty) {
      await clearSession();
      return null;
    }

    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/customer/auth/profile',
        requiresAuth: true,
        fromJsonData: (data) =>
            data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (response.success && response.data != null) {
        final userData = response.data!['user'];
        if (userData is Map<String, dynamic>) {
          await updateUser(userData);
        }
        final stats = response.data!['stats'];
        if (stats is Map<String, dynamic>) {
          _profileStats = Map<String, dynamic>.from(stats);
        }
        return _profileStats;
      }
      return _profileStats;
    } on UnauthorizedException {
      await clearSession();
      return null;
    } on ForbiddenException {
      await clearSession();
      return null;
    } catch (e) {
      debugPrint('[SessionManager] Profile refresh failed: $e');
      return _profileStats;
    }
  }

  /// Revoke the backend token when possible, then clear all local auth state.
  Future<void> logout() async {
    try {
      final rt = await _tokenStorage.getRefreshToken();
      await _apiClient.post<void>(
        '/customer/auth/logout',
        body: rt != null ? {'refresh_token': rt} : null,
        requiresAuth: true,
      );
    } catch (e) {
      debugPrint('[SessionManager] Logout request failed: $e');
    } finally {
      await clearSession();
    }
  }

  /// Clear session securely on logout
  Future<void> clearSession() async {
    _currentUser = null;
    _profileStats = null;
    currentUserNotifier.value = null;
    await _tokenStorage.clearAuth();
  }

  /// Check whether onboarding has already been completed
  Future<bool> isOnboardingCompleted() async {
    return await _tokenStorage.isOnboardingCompleted();
  }

  /// Mark onboarding as completed
  Future<void> setOnboardingCompleted() async {
    await _tokenStorage.setOnboardingCompleted();
  }
}
