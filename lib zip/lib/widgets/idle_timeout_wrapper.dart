import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Wraps the app and signs the user out after [timeout] of no touch
/// activity anywhere on screen. Uses [Listener] (not [GestureDetector]) so
/// it observes every pointer event without intercepting gestures meant for
/// widgets underneath.
class IdleTimeoutWrapper extends StatefulWidget {
  final Widget child;
  final Duration timeout;

  const IdleTimeoutWrapper({
    super.key,
    required this.child,
    this.timeout = const Duration(minutes: 5),
  });

  @override
  State<IdleTimeoutWrapper> createState() => _IdleTimeoutWrapperState();
}

class _IdleTimeoutWrapperState extends State<IdleTimeoutWrapper> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(widget.timeout, _onIdleTimeout);
  }

  Future<void> _onIdleTimeout() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
