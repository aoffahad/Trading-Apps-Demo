import 'dart:convert';

import '../../auth/controller/auth_controller.dart';
import '../../../services/api_call_method.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../models/open_trade_models.dart';

sealed class OpenTradesResult {}

class OpenTradesSuccess extends OpenTradesResult {
  OpenTradesSuccess(this.trades, this.totalProfit);
  final List<OpenTradeModel> trades;
  /// Sum of all [OpenTradeModel.profit].
  final double totalProfit;
}

class OpenTradesFailure extends OpenTradesResult {
  OpenTradesFailure(this.message);
  final String message;
}

/// Fetches open trades via GetOpenTrades API (POST with login + token).
class OpenTradeController {
  OpenTradeController._();

  /// Calls GetOpenTrades. Sends userId and token from storage.
  static Future<OpenTradesResult> fetchOpenTrades() async {
    final userId = await StorageService.getUserId();
    final token = await AuthController.getToken();

    if (userId == null || userId.isEmpty) {
      return OpenTradesFailure('Not logged in');
    }
    if (token == null || token.isEmpty) {
      return OpenTradesFailure('Session expired. Please log in again.');
    }

    final uri = Uri.parse(ApiService.openTrades);
    final response = await ApiCallMethod.post(
      uri,
      body: <String, dynamic>{
        'login': userId,
        'token': token,
      },
    );

    if (response.statusCode != 200) {
      return OpenTradesFailure(
        response.error ?? 'Something went wrong',
      );
    }

    List<OpenTradeModel> trades;
    try {
      final decoded = jsonDecode(response.body);
      trades = OpenTradeModel.listFromJson(decoded);
    } catch (_) {
      return OpenTradesFailure('Invalid response');
    }
    final totalProfit = trades.fold<double>(0.0, (sum, t) => sum + t.profit);
    return OpenTradesSuccess(trades, totalProfit);
  }
}
