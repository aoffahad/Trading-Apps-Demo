import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_strings.dart';

class ApiResponse {
  const ApiResponse({
    required this.statusCode,
    required this.body,
    this.data,
    this.error,
  });

  final int statusCode;
  final String body;
  final Map<String, dynamic>? data;
  final String? error;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// True when the failure was due to network (no internet, timeout, etc.).
  bool get isNetworkError => statusCode == 0;
}

abstract final class ApiCallMethod {
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    if (headers == null || headers.isEmpty) return Map.from(_defaultHeaders);
    return {..._defaultHeaders, ...headers};
  }

  static String _userFriendlyMessage(Object error) {
    final s = error.toString().toLowerCase();
    if (s.contains('socket') ||
        s.contains('connection refused') ||
        s.contains('network') ||
        s.contains('failed host lookup') ||
        s.contains('no internet')) {
      return AppStrings.noInternet;
    }
    if (s.contains('timeout') || s.contains('timed out')) {
      return AppStrings.requestTimeout;
    }
    return AppStrings.connectionError;
  }

  static Future<ApiResponse> _handleResponse(http.Response response) async {
    final body = response.body;
    Map<String, dynamic>? data;
    try {
      if (body.isNotEmpty) {
        data = jsonDecode(body) as Map<String, dynamic>?;
      }
    } catch (_) {}
    return ApiResponse(
      statusCode: response.statusCode,
      body: body,
      data: data,
      error: response.statusCode >= 400
          ? (data?['message'] as String? ?? body)
          : null,
    );
  }

  static Future<ApiResponse> _safeCall(
    Future<http.Response> Function() call,
  ) async {
    try {
      final response = await call();
      return _handleResponse(response);
    } on TimeoutException catch (e) {
      return ApiResponse(
        statusCode: 0,
        body: '',
        error: _userFriendlyMessage(e),
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 0,
        body: '',
        error: _userFriendlyMessage(e),
      );
    }
  }

  /// GET request.
  static Future<ApiResponse> get(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _safeCall(() => http
        .get(uri, headers: _mergeHeaders(headers))
        .timeout(timeout ?? const Duration(seconds: 30)));
  }

  /// POST request.
  static Future<ApiResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    final encoded = body != null ? jsonEncode(body) : null;
    return _safeCall(() => http
        .post(uri, headers: _mergeHeaders(headers), body: encoded)
        .timeout(timeout ?? const Duration(seconds: 30)));
  }

  /// PATCH request.
  static Future<ApiResponse> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    final encoded = body != null ? jsonEncode(body) : null;
    return _safeCall(() => http
        .patch(uri, headers: _mergeHeaders(headers), body: encoded)
        .timeout(timeout ?? const Duration(seconds: 30)));
  }

  /// PUT request.
  static Future<ApiResponse> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    final encoded = body != null ? jsonEncode(body) : null;
    return _safeCall(() => http
        .put(uri, headers: _mergeHeaders(headers), body: encoded)
        .timeout(timeout ?? const Duration(seconds: 30)));
  }

  /// DELETE request.
  static Future<ApiResponse> delete(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _safeCall(() => http
        .delete(uri, headers: _mergeHeaders(headers))
        .timeout(timeout ?? const Duration(seconds: 30)));
  }
}
