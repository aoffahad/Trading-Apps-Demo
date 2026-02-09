/// Single open trade from GetOpenTrades API.
class OpenTradeModel {
  const OpenTradeModel({
    required this.currentPrice,
    this.comment,
    required this.digits,
    required this.login,
    required this.openPrice,
    required this.openTime,
    required this.profit,
    required this.sl,
    required this.swaps,
    required this.symbol,
    required this.tp,
    required this.ticket,
    required this.type,
    required this.volume,
  });

  final double currentPrice;
  final String? comment;
  final int digits;
  final int login;
  final double openPrice;
  final String openTime;
  final double profit;
  final double sl;
  final double swaps;
  final String symbol;
  final double tp;
  final int ticket;
  /// 0 = buy, 1 = sell
  final int type;
  final double volume;

  static OpenTradeModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    try {
      return OpenTradeModel(
        currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0,
        comment: json['comment'] as String?,
        digits: json['digits'] as int? ?? 0,
        login: json['login'] as int? ?? 0,
        openPrice: (json['openPrice'] as num?)?.toDouble() ?? 0,
        openTime: json['openTime'] as String? ?? '',
        profit: (json['profit'] as num?)?.toDouble() ?? 0,
        sl: (json['sl'] as num?)?.toDouble() ?? 0,
        swaps: (json['swaps'] as num?)?.toDouble() ?? 0,
        symbol: json['symbol'] as String? ?? '',
        tp: (json['tp'] as num?)?.toDouble() ?? 0,
        ticket: json['ticket'] as int? ?? 0,
        type: json['type'] as int? ?? 0,
        volume: (json['volume'] as num?)?.toDouble() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }

  static List<OpenTradeModel> listFromJson(dynamic json) {
    if (json is! List) return [];
    final list = <OpenTradeModel>[];
    for (final e in json) {
      final item = fromJson(e as Map<String, dynamic>?);
      if (item != null) list.add(item);
    }
    return list;
  }
}
