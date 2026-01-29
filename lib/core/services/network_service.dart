import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

extension ConnectionStatusExt on InternetStatus {
  bool get connected => this == InternetStatus.connected;
  bool get disconnected => this == InternetStatus.disconnected;
}

class NetworkService {
  NetworkService();

  final _internetChecker = InternetConnection().hasInternetAccess;
  final _listeners = <StreamSubscription<InternetStatus>>[];

  Future<bool> get isConnected => _internetChecker;

  void addListener(void Function(InternetStatus) listener) {
    final listener1 = InternetConnection().onStatusChange.listen(listener);
    _listeners.add(listener1);
  }

  void dispose() {
    for (final listener in _listeners) {
      listener.cancel();
    }
  }
}