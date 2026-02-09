/// Account information from GetAccountInformation API.
class UserAccountInfo {
  const UserAccountInfo({
    required this.address,
    required this.balance,
    required this.city,
    required this.country,
    required this.currency,
    required this.currentTradesCount,
    required this.currentTradesVolume,
    required this.equity,
    required this.freeMargin,
    required this.isAnyOpenTrades,
    required this.isSwapFree,
    required this.leverage,
    required this.name,
    required this.phone,
    required this.totalTradesCount,
    required this.totalTradesVolume,
    required this.type,
    required this.verificationLevel,
    required this.zipCode,
  });

  final String address;
  final double balance;
  final String city;
  final String country;
  final int currency;
  final int currentTradesCount;
  final double currentTradesVolume;
  final double equity;
  final double freeMargin;
  final bool isAnyOpenTrades;
  final bool isSwapFree;
  final int leverage;
  final String name;
  final String phone;
  final int totalTradesCount;
  final double totalTradesVolume;
  final int type;
  final int verificationLevel;
  final String zipCode;

  static UserAccountInfo? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    try {
      return UserAccountInfo(
        address: json['address'] as String? ?? '',
        balance: (json['balance'] as num?)?.toDouble() ?? 0,
        city: json['city'] as String? ?? '',
        country: json['country'] as String? ?? '',
        currency: json['currency'] as int? ?? 0,
        currentTradesCount: json['currentTradesCount'] as int? ?? 0,
        currentTradesVolume:
            (json['currentTradesVolume'] as num?)?.toDouble() ?? 0,
        equity: (json['equity'] as num?)?.toDouble() ?? 0,
        freeMargin: (json['freeMargin'] as num?)?.toDouble() ?? 0,
        isAnyOpenTrades: json['isAnyOpenTrades'] as bool? ?? false,
        isSwapFree: json['isSwapFree'] as bool? ?? false,
        leverage: json['leverage'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        totalTradesCount: json['totalTradesCount'] as int? ?? 0,
        totalTradesVolume:
            (json['totalTradesVolume'] as num?)?.toDouble() ?? 0,
        type: json['type'] as int? ?? 0,
        verificationLevel: json['verificationLevel'] as int? ?? 0,
        zipCode: json['zipCode'] as String? ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
