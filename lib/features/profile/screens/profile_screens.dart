import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controller/user_profile_details_controller.dart';
import '../models/user_profile_details_model.dart';

/// Profile tab screen — dark theme, balance, trades stats, personal info. No nav bar.
/// Fetches account info on load; shows snackbar on error.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  UserAccountInfo? _profile;
  bool _swapFree = false;
  bool _openTrade = false;
  /// Last 4 digits of phone from GetLastFourNumbersPhone API.
  String? _lastFourPhone;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _profile = null;
      _lastFourPhone = null;
    });
    final result = await UserProfileDetailsController.fetchAccountInfo();
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case ProfileDetailsSuccess(:final data):
        setState(() {
          _profile = data;
          _swapFree = data.isSwapFree;
        });
        final lastFour = await UserProfileDetailsController.fetchLastFourPhone();
        if (mounted) setState(() => _lastFourPhone = lastFour);
      case ProfileDetailsFailure():
        setState(() => _profile = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.somethingWentWrong),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileBackground,
      body: SafeArea(
        child: _loading
            ? const LoadingIndicator()
            : _profile == null
                ? _buildPlaceholder()
                : _buildContent(_profile!),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Unable to load profile',
            style: TextStyle(
              color: AppColors.profileTextSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _loadProfile,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(UserAccountInfo p) {
    final initial = p.name.isNotEmpty ? p.name.substring(0, 1).toUpperCase() : '?';
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: _buildHeader(initial, p.name, p.verificationLevel),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildBalanceCard(p),
              const SizedBox(height: 16),
              _buildTradesRow(p),
              const SizedBox(height: 16),
              _buildPersonalInfoCard(p),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String initial, String displayName, int verificationLevel) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.profileAvatarBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  color: AppColors.profileText,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Verification Level: $verificationLevel',
                style: TextStyle(
                  color: AppColors.profileTextSecondary.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
              Row(children: [
                Icon(Icons.call_outlined, color: AppColors.profileTextSecondary.withValues(alpha: 0.9), size: 16),
                Text("******2233", style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.9), fontSize: 13),),
              ],)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(UserAccountInfo p) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.profileCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BALANCE',
                style: TextStyle(
                  color: AppColors.profileText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(
                Icons.show_chart_rounded,
                color: AppColors.profileAccent,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$ ${p.balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.profileAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'EQUITY: \$ ${p.equity.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.profileText,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FREE MARGIN  \$ ${p.freeMargin.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.profileText.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'SWAP FREE',
                style: TextStyle(
                  color: AppColors.profileAccent.withValues(alpha: 0.95),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // const SizedBox(width: 12),
              Theme(
                data: Theme.of(context).copyWith(
                  switchTheme: SwitchThemeData(
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.profileAccent;
                      }
                      return AppColors.profileTextSecondary;
                    }),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.profileAccent.withValues(alpha: 0.5);
                      }
                      return AppColors.profileTextSecondary.withValues(alpha: 0.3);
                    }),
                  ),
                ),
                child: Switch(
                  value: _swapFree,
                  onChanged: (v) => setState(() => _swapFree = v),
                ),
              ),
              Spacer(),
              Text(
                'OPEN TRADE',
                style: TextStyle(
                  color: AppColors.profileAccent.withValues(alpha: 0.95),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // const SizedBox(width: 12),
              Theme(
                data: Theme.of(context).copyWith(
                  switchTheme: SwitchThemeData(
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.profileAccent;
                      }
                      return AppColors.profileTextSecondary;
                    }),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.profileAccent.withValues(alpha: 0.5);
                      }
                      return AppColors.profileTextSecondary.withValues(alpha: 0.3);
                    }),
                  ),
                ),
                child: Switch(
                  value: _openTrade,
                  onChanged: (v) => setState(() => _openTrade = v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradesRow(UserAccountInfo p) {
    final openText = p.isAnyOpenTrades
        ? '${p.currentTradesCount} Open Trades'
        : '0 Open Trades';
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'CURRENT TRADES',
            openText,
            '${p.currentTradesVolume.toStringAsFixed(2)} Volume',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'TOTAL TRADES',
            '${p.totalTradesCount} Trades',
            '${p.totalTradesVolume.toStringAsFixed(2)} Volume',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String mainText, String subText) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.profileCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.profileText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            mainText,
            style: const TextStyle(
              color: AppColors.profileText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: TextStyle(
              color: AppColors.profileTextSecondary.withValues(alpha: 0.9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.bar_chart_rounded,
              color: AppColors.profileAccent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(UserAccountInfo p) {
    final phoneDisplay = _lastFourPhone != null
        ? '******$_lastFourPhone'
        : '********';
    final entries = [
      _InfoRow(icon: Icons.location_on_outlined, label: 'Address', value: p.address),
      _InfoRow(icon: Icons.location_city_outlined, label: 'City', value: p.city),
      _InfoRow(icon: Icons.flag_outlined, label: 'Country', value: p.country),
      _InfoRow(icon: Icons.pin_outlined, label: 'Zip Code', value: p.zipCode),
      _InfoRow(icon: Icons.calculate_outlined, label: 'Leverage', value: '${p.leverage}'),
      _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: phoneDisplay, isPhone: true),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.profileCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PERSONAL INFORMATION',
            style: TextStyle(
              color: AppColors.profileText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          ...entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(e.icon, color: AppColors.profileTextSecondary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: e.isPhone
                        ? Text(
                            '${e.label}: ${e.value}',
                            style: TextStyle(
                              color: AppColors.profileTextSecondary.withValues(alpha: 0.9),
                              fontSize: 13,
                            ),
                          )
                        : Text(
                            '${e.label}: ${e.value}',
                            style: const TextStyle(
                              color: AppColors.profileText,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isPhone = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool isPhone;
}
