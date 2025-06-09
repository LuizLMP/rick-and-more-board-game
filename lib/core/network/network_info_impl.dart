import 'dart:io';
import 'package:board_game_rick_morty/core/network/interfaces/network_info.dart';

class NetworkInfoImpl implements NetworkInfo{
  
  @override
  Future<bool> get isConnected async {
    try{
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}