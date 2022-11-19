import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:frontend/locator.dart';
import 'dart:math' as math;

class NetWorkSpeedViewModel extends ChangeNotifier {
  final io.Socket _socket = locator.get<io.Socket>();
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];
  final double _step = 10;
  final _limitCount = 10;
  double _xValue = 0;
  double _x2Value = 0;
  double dow = 0.0;
  double up = 0.0;
  dynamic netWorkSpeedNotifierLinster(dynamic data) {
    dow = data["in"];
    up = data["out"];
    while (sinPoints.length > _limitCount) {
      sinPoints.removeAt(0);
      cosPoints.removeAt(0);
    }
    sinPoints.add(FlSpot(_xValue, math.sin(_xValue)));
    cosPoints.add(FlSpot(_x2Value, math.cos(_x2Value)));
    notifyListeners();
    if (dow > 1) {
      _xValue = dow / _step;
      _x2Value = up / _step;
    } else {
      _xValue = dow;
      _x2Value = up;
    }
    // logger.d("$_xValue --  $_x2Value");
  }

  void startNetWorkSpeed() {
    if (_socket.active) {
      _socket.on("networkspeed", netWorkSpeedNotifierLinster);
      _socket.emit("startNetWorkSpeed", "Start netWorkSpeed emitter");
      logger.d("sent Start Request for NetWorkSpeed");
    }
  }

  void stopNetWorkSpeed() {
    if (_socket.active) {
      _socket.emit("stopNetWorkSpeed", "Start netWorkSpeed emitter");
      logger.d("sent Stop Request NetWorkSpeed");
      sinPoints.clear();
      cosPoints.clear();
      notifyListeners();
    }
  }

  bool _disposed = false;
  @override
  void dispose() async {
    try {
      if (_socket.connected) {
        stopNetWorkSpeed();
      }
    } catch (e) {
      logger.e("OnError --> $e");
    }
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
