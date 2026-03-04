import 'dart:async';
import 'package:cypher_task_app/utils/constants.dart';

typedef SessionTimeoutCallback = Future<void> Function();

class SessionService {
  Timer? _inactivityTimer;
  final Duration _timeoutDuration =
      Duration(seconds: AppConstants.sessionTimeoutMilliseconds ~/ 1000);

  SessionTimeoutCallback? _onSessionTimeout;
  bool _isSessionActive = false;

  /// Initialize session with callback for timeout
  void initializeSession({required SessionTimeoutCallback onSessionTimeout}) {
    _onSessionTimeout = onSessionTimeout;
    _isSessionActive = true;
    _resetInactivityTimer();
  }

  /// Reset the inactivity timer (call this on user interaction)
  void resetInactivityTimer() {
    if (!_isSessionActive) return;
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeoutDuration, _handleSessionTimeout);
  }

  Future<void> _handleSessionTimeout() async {
    _isSessionActive = false;
    if (_onSessionTimeout != null) {
      await _onSessionTimeout!();
    }
  }

  /// Manually end the session
  void endSession() {
    _inactivityTimer?.cancel();
    _isSessionActive = false;
  }

  /// Resume an existing session
  void resumeSession() {
    _isSessionActive = true;
    resetInactivityTimer();
  }

  /// Check if session is active
  bool get isSessionActive => _isSessionActive;

  /// Get remaining timeout duration
  int? getTimeoutDuration() {
    return _inactivityTimer?.tick;
  }

  /// Dispose resources
  void dispose() {
    _inactivityTimer?.cancel();
  }
}
