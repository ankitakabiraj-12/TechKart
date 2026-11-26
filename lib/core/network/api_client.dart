import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'token_storage.dart';
import 'wishlist_models.dart';
import 'catalog_models.dart';

class ApiClient {
  // Performance: In-memory cache for idempotent GET requests with TTL
  static final Map<String, _CachedResponse> _responseCache = {};

  static void clearCache() {
    _responseCache.clear();
  }

  final http.Client _httpClient;
  final TokenStorage _tokenStorage;
  String _baseUrl;

  ApiClient({
    http.Client? httpClient,
    TokenStorage? tokenStorage,
    String? baseUrl,
  }) : _httpClient = httpClient ?? http.Client(),
       _tokenStorage = tokenStorage ?? TokenStorage(),
       _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  TokenStorage get tokenStorage => _tokenStorage;
  String get baseUrl => _baseUrl;

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final base = _baseUrl.endsWith('/') ? _baseUrl : '$_baseUrl/';
    final fullUrl = '$base$cleanPath';

    final uri = Uri.parse(fullUrl);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final stringParams = queryParameters.map(
        (k, v) => MapEntry(k, v.toString()),
      );
      return uri.replace(
        queryParameters: {...uri.queryParameters, ...stringParams},
      );
    }
    return uri;
  }

  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Duration? connectTimeout,
    Duration? responseTimeout,
    T Function(dynamic data)? fromJsonData,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final finalHeaders = await _buildHeaders(
      extraHeaders: headers,
      requiresAuth: requiresAuth,
    );

    return _executeRequest<T>(
      method: 'GET',
      uri: uri,
      headers: finalHeaders,
      connectTimeout: connectTimeout,
      responseTimeout: responseTimeout,
      fromJsonData: fromJsonData,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Duration? connectTimeout,
    Duration? responseTimeout,
    T Function(dynamic data)? fromJsonData,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final finalHeaders = await _buildHeaders(
      extraHeaders: headers,
      requiresAuth: requiresAuth,
    );

    return _executeRequest<T>(
      method: 'POST',
      uri: uri,
      headers: finalHeaders,
      body: body,
      connectTimeout: connectTimeout,
      responseTimeout: responseTimeout,
      fromJsonData: fromJsonData,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Duration? connectTimeout,
    Duration? responseTimeout,
    T Function(dynamic data)? fromJsonData,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final finalHeaders = await _buildHeaders(
      extraHeaders: headers,
      requiresAuth: requiresAuth,
    );

    return _executeRequest<T>(
      method: 'PUT',
      uri: uri,
      headers: finalHeaders,
      body: body,
      connectTimeout: connectTimeout,
      responseTimeout: responseTimeout,
      fromJsonData: fromJsonData,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Duration? connectTimeout,
    Duration? responseTimeout,
    T Function(dynamic data)? fromJsonData,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final finalHeaders = await _buildHeaders(
      extraHeaders: headers,
      requiresAuth: requiresAuth,
    );

    return _executeRequest<T>(
      method: 'DELETE',
      uri: uri,
      headers: finalHeaders,
      body: body,
      connectTimeout: connectTimeout,
      responseTimeout: responseTimeout,
      fromJsonData: fromJsonData,
    );
  }

  // ---------------------------------------------------------------------------
  // Customer Wishlist API Endpoints (SCR-24)
  // ---------------------------------------------------------------------------

  /// GET /customer/wishlist
  Future<ApiResponse<WishlistDataModel>> getWishlist() async {
    return get<WishlistDataModel>(
      '/customer/wishlist',
      requiresAuth: true,
      fromJsonData: (data) =>
          WishlistDataModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// POST /customer/wishlist (body: { product_id: int })
  Future<ApiResponse<WishlistDataModel>> addToWishlist(int productId) async {
    return post<WishlistDataModel>(
      '/customer/wishlist',
      body: {'product_id': productId},
      requiresAuth: true,
      fromJsonData: (data) =>
          WishlistDataModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// DELETE /customer/wishlist/{id}
  Future<ApiResponse<WishlistDataModel>> removeFromWishlist(int id) async {
    return delete<WishlistDataModel>(
      '/customer/wishlist/$id',
      requiresAuth: true,
      fromJsonData: (data) =>
          WishlistDataModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// DELETE /customer/wishlist (Clear all)
  Future<ApiResponse<WishlistDataModel>> clearWishlist() async {
    return delete<WishlistDataModel>(
      '/customer/wishlist',
      requiresAuth: true,
      fromJsonData: (data) =>
          WishlistDataModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Sends the HTTP request with separate connection and response timeouts.
  Future<ApiResponse<T>> _executeRequest<T>({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    dynamic body,
    Duration? connectTimeout,
    Duration? responseTimeout,
    T Function(dynamic data)? fromJsonData,
  }) async {
    final effectiveConnectTimeout = connectTimeout ?? ApiConfig.connectTimeout;
    final effectiveResponseTimeout =
        responseTimeout ?? ApiConfig.responseTimeout;

    try {
      final request = http.Request(method, uri);
      request.headers.addAll(headers);

      if (body != null) {
        request.body = jsonEncode(body);
      }

      // Step 1: Enforce Connection Timeout during socket/handshake initiation
      final http.StreamedResponse streamedResponse = await _httpClient
          .send(request)
          .timeout(
            effectiveConnectTimeout,
            onTimeout: () => throw const ConnectionTimeoutException(),
          );

      // Step 2: Enforce Response Timeout during body streaming & reception
      final responseBody = await streamedResponse.stream
          .bytesToString()
          .timeout(
            effectiveResponseTimeout,
            onTimeout: () => throw const ResponseTimeoutException(),
          );

      final httpResponse = http.Response(
        responseBody,
        streamedResponse.statusCode,
        headers: {
          ...streamedResponse.headers,
          'content-type': 'application/json; charset=utf-8',
        },
        request: streamedResponse.request,
        isRedirect: streamedResponse.isRedirect,
        persistentConnection: streamedResponse.persistentConnection,
        reasonPhrase: streamedResponse.reasonPhrase,
      );

      return _handleResponse<T>(
        httpResponse,
        rawBody: responseBody,
        fromJsonData: fromJsonData,
      );
    } on ConnectionTimeoutException {
      final fallback = await _tryLanFallback<T>(
        method: method,
        uri: uri,
        headers: headers,
        body: body,
        connectTimeout: effectiveConnectTimeout,
        responseTimeout: effectiveResponseTimeout,
        fromJsonData: fromJsonData,
      );
      if (fallback != null) return fallback;
      rethrow;
    } on ResponseTimeoutException {
      rethrow;
    } on TimeoutException {
      final fallback = await _tryLanFallback<T>(
        method: method,
        uri: uri,
        headers: headers,
        body: body,
        connectTimeout: effectiveConnectTimeout,
        responseTimeout: effectiveResponseTimeout,
        fromJsonData: fromJsonData,
      );
      if (fallback != null) return fallback;
      throw const ConnectionTimeoutException();
    } on SocketException {
      final fallback = await _tryLanFallback<T>(
        method: method,
        uri: uri,
        headers: headers,
        body: body,
        connectTimeout: effectiveConnectTimeout,
        responseTimeout: effectiveResponseTimeout,
        fromJsonData: fromJsonData,
      );
      if (fallback != null) return fallback;
      throw const NetworkException();
    } on http.ClientException {
      final fallback = await _tryLanFallback<T>(
        method: method,
        uri: uri,
        headers: headers,
        body: body,
        connectTimeout: effectiveConnectTimeout,
        responseTimeout: effectiveResponseTimeout,
        fromJsonData: fromJsonData,
      );
      if (fallback != null) return fallback;
      throw const NetworkException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Unexpected network error: $e');
    }
  }

  Future<ApiResponse<T>?> _tryLanFallback<T>({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    dynamic body,
    required Duration connectTimeout,
    required Duration responseTimeout,
    T Function(dynamic data)? fromJsonData,
  }) async {
    final usesLoopback =
        _baseUrl.contains('127.0.0.1') || _baseUrl.contains('localhost');
    if (kIsWeb || !Platform.isAndroid || !usesLoopback) return null;

    try {
      final fallbackUri = Uri.parse(
        uri.toString().replaceFirst(_baseUrl, ApiConfig.fallbackBaseUrl),
      );
      final request = http.Request(method, fallbackUri);
      request.headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);

      final streamedResponse = await _httpClient
          .send(request)
          .timeout(connectTimeout);
      final responseBody = await streamedResponse.stream
          .bytesToString()
          .timeout(responseTimeout);
      final response = http.Response(
        responseBody,
        streamedResponse.statusCode,
        headers: {
          ...streamedResponse.headers,
          'content-type': 'application/json; charset=utf-8',
        },
        request: streamedResponse.request,
        isRedirect: streamedResponse.isRedirect,
        persistentConnection: streamedResponse.persistentConnection,
        reasonPhrase: streamedResponse.reasonPhrase,
      );

      ApiConfig.baseUrl = ApiConfig.fallbackBaseUrl;
      _baseUrl = ApiConfig.fallbackBaseUrl;
      return _handleResponse<T>(
        response,
        rawBody: responseBody,
        fromJsonData: fromJsonData,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      return null;
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response, {
    String? rawBody,
    T Function(dynamic data)? fromJsonData,
  }) {
    final statusCode = response.statusCode;
    Map<String, dynamic> jsonBody = {};

    try {
      final bodyText = rawBody ??
          (response.bodyBytes.isNotEmpty
              ? utf8.decode(response.bodyBytes, allowMalformed: true)
              : response.body);
      if (bodyText.isNotEmpty) {
        final decoded = jsonDecode(bodyText);
        if (decoded is Map<String, dynamic>) {
          jsonBody = decoded;
        } else {
          jsonBody = {'data': decoded};
        }
      }
    } catch (_) {
      jsonBody = {'message': response.body};
    }

    final message = jsonBody['message'] as String? ?? 'Request failed';
    final errors = jsonBody['errors'] ?? jsonBody['error'];

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse.fromJson(
        jsonBody,
        statusCode,
        fromJsonData: fromJsonData,
      );
    }

    switch (statusCode) {
      case 400:
        throw ValidationException(message: message, details: errors);
      case 401:
        throw UnauthorizedException(message: message, details: errors);
      case 403:
        throw ForbiddenException(message: message, details: errors);
      case 404:
        throw NotFoundException(message: message, details: errors);
      case 409:
        throw ConflictException(message: message, details: errors);
      case 422:
        throw ValidationException(message: message, details: errors);
      case 500:
      default:
        throw ServerException(
          message: message,
          statusCode: statusCode,
          details: errors,
        );
    }
  }

  /// Fetch active categories from backend (defaults to root 45 categories)
  /// GET /customer/categories?parent_id=root
  Future<ApiResponse<List<CategoryModel>>> getCategories({String parentId = 'root'}) async {
    return get<List<CategoryModel>>(
      'customer/categories',
      queryParameters: {'parent_id': parentId},
      requiresAuth: false,
      fromJsonData: (data) {
        if (data is List) {
          return data
              .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  /// Fetch active subcategories for a category from backend
  /// GET /customer/categories/{id}/subcategories
  Future<ApiResponse<List<CategoryModel>>> getSubcategories(int categoryId) async {
    return get<List<CategoryModel>>(
      'customer/categories/$categoryId/subcategories',
      requiresAuth: false,
      fromJsonData: (data) {
        if (data is Map && data['subcategories'] is List) {
          return (data['subcategories'] as List)
              .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
              .toList();
        } else if (data is List) {
          return data
              .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  /// Fetch products with optional category, subcategory, search filtering
  /// GET /customer/products
  Future<ApiResponse<List<ProductModel>>> getProducts({
    int? categoryId,
    int? subcategoryId,
    String? search,
    String? sort,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (categoryId != null) query['category_id'] = categoryId;
    if (subcategoryId != null) query['subcategory_id'] = subcategoryId;
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
      query['q'] = search;
    }
    if (sort != null && sort.isNotEmpty) query['sort'] = sort;

    return get<List<ProductModel>>(
      'customer/products',
      queryParameters: query,
      requiresAuth: false,
      fromJsonData: (data) {
        if (data is Map && data['products'] is List) {
          return (data['products'] as List)
              .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
              .toList();
        } else if (data is List) {
          return data
              .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  /// Fetch single product details by id or slug
  /// GET /customer/products/{id}
  Future<ApiResponse<ProductModel>> getProduct(dynamic idOrSlug) async {
    return get<ProductModel>(
      'customer/products/$idOrSlug',
      requiresAuth: false,
      fromJsonData: (data) => ProductModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Fetch verified brands for a subcategory
  /// GET /customer/subcategories/{id}/brands
  Future<ApiResponse<List<BrandModel>>> getSubcategoryBrands(int subcategoryId) async {
    return get<List<BrandModel>>(
      'customer/subcategories/$subcategoryId/brands',
      requiresAuth: false,
      fromJsonData: (data) {
        if (data is Map && data['brands'] is List) {
          return (data['brands'] as List)
              .map((b) => BrandModel.fromJson(b as Map<String, dynamic>))
              .toList();
        } else if (data is List) {
          return data
              .map((b) => BrandModel.fromJson(b as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  /// Fetch verified brands for a category
  /// GET /customer/brands?category_id={categoryId}
  Future<ApiResponse<List<BrandModel>>> getCategoryBrands(int categoryId) async {
    return get<List<BrandModel>>(
      'customer/brands',
      queryParameters: {'category_id': categoryId},
      requiresAuth: false,
      fromJsonData: (data) {
        if (data is Map && data['brands'] is List) {
          return (data['brands'] as List)
              .map((b) => BrandModel.fromJson(b as Map<String, dynamic>))
              .toList();
        } else if (data is List) {
          return data
              .map((b) => BrandModel.fromJson(b as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  /// Add item to cart with variant support
  /// POST /customer/cart
  Future<ApiResponse<Map<String, dynamic>>> addToCart({
    required int productId,
    int? variantId,
    int? listingId,
    int quantity = 1,
  }) async {
    final body = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
    };
    if (variantId != null) body['variant_id'] = variantId;
    if (listingId != null) body['listing_id'] = listingId;

    return post<Map<String, dynamic>>(
      'customer/cart',
      body: body,
      requiresAuth: true,
      fromJsonData: (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
  }

  /// Get customer cart
  /// GET /customer/cart
  Future<ApiResponse<Map<String, dynamic>>> getCart() async {
    return get<Map<String, dynamic>>(
      'customer/cart',
      requiresAuth: true,
      fromJsonData: (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
  }

  void close() {
    _httpClient.close();
  }
}


class _CachedResponse {
  final dynamic response;
  final DateTime timestamp;
  final Duration ttl;

  _CachedResponse(this.response, this.ttl) : timestamp = DateTime.now();

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}
