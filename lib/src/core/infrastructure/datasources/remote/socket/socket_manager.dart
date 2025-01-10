import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../../../common/utils/logger.dart';

class SocketManager {
  late io.Socket socket;

  SocketManager._privateConstructor();
  static final SocketManager instance = SocketManager._privateConstructor();

  void initialize(String socketUrl, int userId) {
    socket = io.io(
        socketUrl, io.OptionBuilder().setTransports(['websocket']).build());
    socket.connect();

    socket.onConnect((_) {
      socket.emit('online', userId);
      logger.i('Socket connected');
    });

    socket.onDisconnect((_) => logger.i('Socket disconnected'));
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
      logger.i('Socket manually disconnected');
    }
  }

  void dispose() {
    socket.dispose();
  }
}
