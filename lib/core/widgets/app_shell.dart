import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_strings.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget? child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOffline = false;
  bool _hadOfflineBanner = false;
  /// When false, connectivity_plus is not available (e.g. web, some desktop) — skip banner.
  bool _connectivityAvailable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (!mounted) return;
      _updateOffline(results);
      _subscription =
          Connectivity().onConnectivityChanged.listen(_updateOffline);
    } on MissingPluginException catch (_) {
      if (!mounted) return;
      setState(() => _connectivityAvailable = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _connectivityAvailable = false);
    }
  }

  void _updateOffline(List<ConnectivityResult> results) {
    final offline = results.isEmpty ||
        (results.length == 1 && results.first == ConnectivityResult.none);
    if (!mounted) return;
    setState(() {
      final wasOffline = _isOffline;
      _isOffline = offline;
      if (wasOffline && !_isOffline) _hadOfflineBanner = true;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Connectivity().checkConnectivity().then(_updateOffline);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child ?? const SizedBox.shrink();
    if (!_connectivityAvailable) return child;

    if (!_isOffline) {
      if (_hadOfflineBanner && mounted) {
        _hadOfflineBanner = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(
              content: const Text(AppStrings.backOnline),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      }
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Material(
            elevation: 2,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: MediaQuery.paddingOf(context).top + 8,
                bottom: 12,
              ),
              color: Colors.orange.shade700,
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Icon(Icons.wifi_off_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        AppStrings.youAreOffline,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
