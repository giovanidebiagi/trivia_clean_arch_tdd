import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'i_network_service.dart';

class NetworkService implements INetworkService {
  final InternetConnectionChecker internetConnectionChecker;

  NetworkService({required this.internetConnectionChecker});

  @override
  Future<bool> get isConnected async {
    if (await internetConnectionChecker.connectionStatus ==
        InternetConnectionStatus.connected) {
      return true;
    }

    return false;
  }
}
