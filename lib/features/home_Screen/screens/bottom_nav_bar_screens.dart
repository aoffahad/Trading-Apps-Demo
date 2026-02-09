import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';
import 'home_screen.dart';
import '../../profile/screens/profile_screens.dart';
import '../../trades/screens/trades_screen.dart';


class BottomNavBarScreens extends StatefulWidget {
  const BottomNavBarScreens({super.key});

  @override
  State<BottomNavBarScreens> createState() => _BottomNavBarScreensState();
}

class _BottomNavBarScreensState extends State<BottomNavBarScreens> {
  int _currentIndex = 0;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.show_chart_rounded, label: 'Trade'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = const [
      HomeScreen(),
      TradesScreen(),
      ProfileScreen(),
    ];
  }

  Future<void> _onBackPressed() async {
    final exit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.profileCard,
        title: Text(
          AppStrings.exitConfirmTitle,
          style: const TextStyle(color: AppColors.profileText),
        ),
        content: Text(
          AppStrings.exitConfirmMessage,
          style: TextStyle(
            color: AppColors.profileTextSecondary.withValues(alpha: 0.9),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppStrings.cancel,
              style: const TextStyle(color: AppColors.profileAccent),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppStrings.exit,
              style: const TextStyle(color: AppColors.tradeLoss),
            ),
          ),
        ],
      ),
    );
    if (exit == true && mounted) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: AppColors.profileBackground,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.profileCard,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Helpers.horizontalPadding(context).clamp(8.0, 24.0),
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                return _NavBarButton(
                  item: _items[index],
                  isSelected: _currentIndex == index,
                  onTap: () {
                    setState(() => _currentIndex = index);
                  },
                );
              }),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.profileAccent.withValues(alpha: 0.2),
          highlightColor: AppColors.profileAccent.withValues(alpha: 0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.profileAccent.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    item.icon,
                    size: 26,
                    color: isSelected
                        ? AppColors.profileAccent
                        : AppColors.profileTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isSelected ? 13 : 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.profileAccent
                        : AppColors.profileTextSecondary,
                  ),
                  child: Text(item.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
