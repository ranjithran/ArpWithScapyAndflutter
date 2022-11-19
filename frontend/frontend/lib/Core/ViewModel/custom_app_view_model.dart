import 'package:flutter/cupertino.dart';
import 'package:frontend/Core/Services/api_service.dart';
import 'package:frontend/locator.dart';
import 'package:network_info_plus/network_info_plus.dart';

class CustomAppViewModel extends ChangeNotifier {
  CustomAppViewModel() {
    setUpInitially();
  }

  String _ifaceValue = "eth0";
  String get ifaceValue => _ifaceValue;
  set ifaceValue(String val) {
    _ifaceValue = val;
    notifyListeners();
  }

  final _info = locator.get<NetworkInfo>();
  final _apiServer = locator.get<ApiService>();
  String get wifiName => _wifiname;
  String get wifiBSSID => _wifiBSSID;
  String get wifiIP => _wifiIP;

  int _devicesList = 0;

  int get devicesList => _devicesList;
  set devicesList(int val) {
    _devicesList = val;
    notifyListeners();
  }

  List<String> ifaces = [];
  String _wifiname = "";
  String _wifiBSSID = "";
  String _wifiIP = "";

  void setUpInitially() async {
    await _info.getWifiName().then((value) {
      _wifiname = value.toString();
    });
    await _info.getWifiBSSID().then((value) {
      _wifiBSSID = value.toString();
    });
    await _info.getWifiIP().then((value) {
      _wifiIP = value.toString();
    });
    await _apiServer.getIfaces().then((value) {
      ifaces = value;
    });

    Future.microtask(
      () => _apiServer.getHostIpWithMacCached().then(
        (value) {
          _devicesList = value.results.length;
          notifyListeners();
        },
      ),
    );
    notifyListeners();
  }
}
