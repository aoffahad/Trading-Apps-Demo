import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controller/open_trade_controller.dart';
import '../models/open_trade_models.dart';
import '../widgets/open_trade_card_widget.dart';

/// Trade tab screen — list of open trade cards from API.
class TradesScreen extends StatefulWidget {
  const TradesScreen({super.key});

  @override
  State<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen> {
  bool _loading = true;
  List<OpenTradeCardData> _items = [];
  double _totalProfit = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTrades();
  }

  Future<void> _loadTrades() async {
    setState(() {
      _loading = true;
      _items = [];
      _totalProfit = 0.0;
    });
    final result = await OpenTradeController.fetchOpenTrades();
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case OpenTradesSuccess(:final trades, :final totalProfit):
        setState(() {
          _items = _toCardDataList(trades);
          _totalProfit = totalProfit;
        });
      case OpenTradesFailure():
        setState(() => _items = []);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.somethingWentWrong),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  /// Called on pull-to-refresh. Keeps current list visible and refreshes data.
  Future<void> _onRefresh() async {
    final result = await OpenTradeController.fetchOpenTrades();
    if (!mounted) return;
    switch (result) {
      case OpenTradesSuccess(:final trades, :final totalProfit):
        setState(() {
          _items = _toCardDataList(trades);
          _totalProfit = totalProfit;
        });
      case OpenTradesFailure():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.somethingWentWrong),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  static List<OpenTradeCardData> _toCardDataList(List<OpenTradeModel> trades) {
    return trades.map(_toCardData).toList();
  }

  static OpenTradeCardData _toCardData(OpenTradeModel t) {
    final assetName = t.symbol.startsWith('#') ? t.symbol.substring(1) : t.symbol;
    final isBuy = t.type == 0;
    final openPriceStr = t.openPrice.toStringAsFixed(t.digits);
    final currentPriceStr = t.currentPrice.toStringAsFixed(t.digits);
    return OpenTradeCardData(
      assetName: assetName,
      openTime: t.openTime.isNotEmpty ? _formatOpenTime(t.openTime) : null,
      isBuy: isBuy,
      openPrice: openPriceStr,
      currentPrice: currentPriceStr,
      profit: t.profit,
      digit: t.digits,
      sl: t.sl.round(),
      swap: t.swaps.round(),
      type: t.type,
      volume: t.volume,
      login: t.login,
      ticket: t.ticket,
    );
  }

  static String _formatOpenTime(String iso) {
    try {
      final dt = DateTime.tryParse(iso);
      if (dt == null) return iso;
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  Color _totalProfitColor() {
    if (_totalProfit > 0) return AppColors.tradeProfit;
    if (_totalProfit < 0) return AppColors.tradeLoss;
    return const Color(0xFF2DD4BF);
  }

  Widget _buildTotalProfitCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.profileCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'TOTAL PROFIT',
            style: TextStyle(
              color: AppColors.profileText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _totalProfit >= 0
                ? '+${_totalProfit.toStringAsFixed(2)}'
                : _totalProfit.toStringAsFixed(2),
            style: TextStyle(
              color: _totalProfitColor(),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileBackground,
      appBar: AppBar(
        backgroundColor: AppColors.profileBackground,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back_ios_new_rounded,
        //     color: AppColors.profileText,
        //   ),
        //   onPressed: () => Navigator.of(context).maybePop(),
        // ),
        title: const Text(
          'OPEN TRADES',
          style: TextStyle(
            color: AppColors.profileText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.profileText),
            onPressed: _loading ? null : _loadTrades,
          ),
        ],
      ),
      body: _loading
          ? const LoadingIndicator()
          : RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.profileAccent,
              backgroundColor: AppColors.profileCard,
              child: _items.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No open trades',
                                style: TextStyle(
                                  color: AppColors.profileTextSecondary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton.icon(
                                onPressed: _loadTrades,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                            child: _buildTotalProfitCard(),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index < _items.length - 1) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: OpenTradeCardWidget(
                                      data: _items[index],
                                      onTap: () {},
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: OpenTradeCardWidget(
                                    data: _items[index],
                                    onTap: () {},
                                  ),
                                );
                              },
                              childCount: _items.length,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
