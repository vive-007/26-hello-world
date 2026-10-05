import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/session_repository.dart';

/// Signs out after [timeout] of no interaction (taps or keys).
/// Wrap the signed-in area with it; the auth gate then returns to login.
class AutoLogout extends StatefulWidget {
  const AutoLogout({
    super.key,
    required this.sessions,
    required this.child,
    this.timeout = const Duration(minutes: 5),
    this.warnBefore = const Duration(seconds: 30),
    this.onTimeout,
  });

  final SessionRepository sessions;
  final Widget child;
  final Duration timeout;
  final Duration warnBefore;
  final VoidCallback? onTimeout;

  @override
  State<AutoLogout> createState() => _AutoLogoutState();
}

class _AutoLogoutState extends State<AutoLogout> {
  Timer? _timer;
  Timer? _warnTimer;
  bool _warned = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
    _reset();
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _timer?.cancel();
    _warnTimer?.cancel();
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    _reset();
    return false; // don't consume the key
  }

  void _reset() {
    _timer?.cancel();
    _warnTimer?.cancel();
    _warned = false;
    if (widget.warnBefore < widget.timeout) {
      _warnTimer = Timer(widget.timeout - widget.warnBefore, _warn);
    }
    _timer = Timer(widget.timeout, _fire);
  }

  void _warn() {
    if (!mounted || _warned) return;
    _warned = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Signing out in ${widget.warnBefore.inSeconds}s due to inactivity.',
        ),
      ),
    );
  }

  Future<void> _fire() async {
    await widget.sessions.signOut();
    widget.onTimeout?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _reset(),
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
