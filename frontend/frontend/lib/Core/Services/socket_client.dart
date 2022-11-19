import 'package:frontend/constants/constants.dart';
import 'package:frontend/locator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClientForMe {
  io.Socket initSocket() {
    io.Socket socket = io.io(mainurl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      logger.d('Connection established');
    });

    socket.onDisconnect((_) => logger.d('Connection Disconnection'));
    socket.onConnectError((err) => logger.d(err));
    socket.onError((err) => logger.d("got error"+err));
    return socket;
  }

  disConncectSocket(io.Socket socket) async {
    socket.emit("stopSniffer", "Stop Sniffer");
    await Future.delayed(const Duration(seconds: 3));
    socket.disconnect();
    logger.d("Socket stopped");
  }
}
