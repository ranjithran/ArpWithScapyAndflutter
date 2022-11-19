import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:frontend/Core/Services/api_service.dart';
import 'package:frontend/locator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class CustomAppViewModel2 extends ChangeNotifier {
  final ApiService _apiService = locator.get<ApiService>();

  bool get socketConnectionStatus => locator.get<io.Socket>().active;

  ServerData _data = ServerData();

  ServerData get data => _data;

  set data(ServerData data) {
    _data = data;
    notifyListeners();
  }

  getServerData() async {
    await _apiService.getServerData().then((value) {
      data = serverDataFromJson(value);
    }).catchError((onError) {
      logger.e("onError $onError");
    });
  }

  updateIfaceName(String iface) async {
    await _apiService.setIfaceName(iface: iface).then((value) {
      String res = json.decode(value)['status'];
      data = serverDataFromJson(res);
    });
  }
}

ServerData serverDataFromJson(String str) => ServerData.fromJson(json.decode(str));

String serverDataToJson(ServerData data) => json.encode(data.toJson());

class ServerData {
  ServerData({
    this.dstIp = "0.0.0.0",
    this.dstmac = "00.00.00.00.00",
    this.networkIface = "--",
    this.srcIp = "0.0.0.0",
    this.srcmac = "00.00.00.00.00",
  });

  String dstIp;
  String dstmac;
  String networkIface;
  String srcIp;
  String srcmac;

  factory ServerData.fromJson(Map<String, dynamic> json) => ServerData(
        dstIp: json.containsKey("dstIp") ? json["dstIp"] : "",
        dstmac: json.containsKey("dstmac") ? json["dstmac"] : "",
        networkIface: json.containsKey("networkIface") ? json["networkIface"] : "",
        srcIp: json.containsKey("srcIp") ? json["srcIp"] : "",
        srcmac: json.containsKey("srcmac") ? json["srcmac"] : "",
      );

  Map<String, dynamic> toJson() => {
        "dstIp": dstIp,
        "dstmac": dstmac,
        "networkIface": networkIface,
        "srcIp": srcIp,
        "srcmac": srcmac,
      };
}
