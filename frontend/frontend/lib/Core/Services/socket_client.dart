import 'package:frontend/constants/constants.dart';
import 'package:frontend/locator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClientForMe {
  io.Socket? socket;

  io.Socket getSocket() {
    if (socket != null && socket!.connected) {
      return socket!;
    }
    socket = initSocket();
    return socket!;
  }

  io.Socket initSocket() {
    io.Socket socket = io.io(mainurl, <String, dynamic>{
      'autoConnect': true,
      'transports': ['websocket'],
    });
  

    socket.onConnect((p) => logger.i(['CONNECT', p]));
    socket.onDisconnect((p) => logger.i(['DISCONNECT', p]));
    socket.onError((p) => logger.i(['ERROR', p]));
    socket.onConnecting((p) => logger.i(['CONNECTING', p]));
    socket.onConnectError((p) => logger.i(['CONNECT ERROR', p]));
    socket.onConnectTimeout((p) => logger.i(['TIMEOUT', p]));
    socket.on('connect_error', (p) => logger.i(['CONNECT ERROR', p]));
    return socket;
  }

  disConncectSocket(io.Socket socket) async {
    socket.emit("stopSniffer", "Stop Sniffer");
    await Future.delayed(const Duration(seconds: 3));
    socket.disconnect();
    logger.d("Socket stopped");
  }
}
