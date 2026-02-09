import 'dart:convert';

import 'package:http/http.dart' as http;


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

  static Future<ApiResponse> _handleResponse(http.Response response) async {
    final body = response.body;
    Map<String, dynamic>? data;
    try {
      if (body.isNotEmpty) {
        data = jsonDecode(body) as Map<String, dynamic>?;
      }
    } catch (_) {
      
    }
    return ApiResponse(
      statusCode: response.statusCode,
      body: body,
      data: data,
      error: response.statusCode >= 400 ? (data?['message'] as String? ?? body) : null,
    );
  }

  /// GET request. 
  static Future<ApiResponse> get(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    final response = await http.get(uri, headers: _mergeHeaders(headers));
    return _handleResponse(response);
  }

  /// POST request 
  static Future<ApiResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final encoded = body != null ? jsonEncode(body) : null;
    final response = await http.post(
      uri,
      headers: _mergeHeaders(headers),
      body: encoded,
    );
    return _handleResponse(response);
  }

  /// PATCH request 
  static Future<ApiResponse> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final encoded = body != null ? jsonEncode(body) : null;
    final response = await http.patch(
      uri,
      headers: _mergeHeaders(headers),
      body: encoded,
    );
    return _handleResponse(response);
  }

  /// PUT request 
  static Future<ApiResponse> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final encoded = body != null ? jsonEncode(body) : null;
    final response = await http.put(
      uri,
      headers: _mergeHeaders(headers),
      body: encoded,
    );
    return _handleResponse(response);
  }

  /// DELETE request.
  static Future<ApiResponse> delete(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    final response = await http.delete(uri, headers: _mergeHeaders(headers));
    return _handleResponse(response);
  }
}
