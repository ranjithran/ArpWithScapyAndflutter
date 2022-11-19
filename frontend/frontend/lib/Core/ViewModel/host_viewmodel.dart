import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Core/JsonModel/nmap_with_ip_mac.dart';
import 'package:frontend/Core/Services/api_service.dart';
import 'package:frontend/locator.dart';

class VictimsViewModel extends ChangeNotifier {
  VictimsViewModel() {
    generateDataCells();
  }
  Stopwatch watch = Stopwatch();
  Timer? timer;
  String elapsedTime = '';

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  List<DataRow> listofDataRows = [];
  final ApiService _apiServer = locator.get<ApiService>();
  Future<void> generateDataCells() async {
    try {
      await _apiServer.getHostIpWithMac().then(
        (value) {
          listofDataRows.clear();
          for (Result result in value.results) {
            listofDataRows.add(DataRow(cells: [
              DataCell(Text(result.ipv4)),
              DataCell(Text(result.vendor)),
              const DataCell(Text("remote")),
              DataCell(Text(result.mac)),
            ]));
          }
        },
      );
      // }
      notifyListeners();
    } on DioError catch (ex) {
      String errorMessage = (ex.message);

      logger.e(errorMessage);
    }
  }
}
