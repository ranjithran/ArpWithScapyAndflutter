import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:frontend/Core/Db/ip_look_up.dart';
import 'package:frontend/Core/Db/packet_table.dart';
import 'package:frontend/Core/JsonModel/nmap_with_ip_mac.dart';

import 'package:frontend/Core/JsonModel/sniffer_data_json_model.dart';
import 'package:frontend/Core/Services/api_service.dart';
import 'package:frontend/Core/Services/iplookup_service.dart';
import 'package:frontend/locator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class AttackViewModel extends ChangeNotifier {
  final ApiService _apiService = locator.get<ApiService>();
  final PacketTable _packetTable = locator.get<PacketTable>();
  final IpLookUpService _ipLookUpService = locator.get<IpLookUpService>();
  final IpLookUpTable _ipLookUpTable = locator.get<IpLookUpTable>();
  final io.Socket _socket = locator.get<io.Socket>();
  List<SnifferDataJsonModel> vals = [];
  ScrollController scrollController = ScrollController();
  IpWithMac _src = IpWithMac("0.0.0.0", "", mac: "00.00.00.00.00.00");

  IpWithMac get src => _src;

  set src(IpWithMac val) {
    _src = val;
    notifyListeners();
  }

  IpWithMac _dst = IpWithMac("0.0.0.0", "", mac: "00.00.00.00.00.00");

  IpWithMac get dst => _dst;
  set dst(IpWithMac val) {
    _dst = val;
    notifyListeners();
  }

  List<IpWithMac> ipvals = [];

  bool _arpWithScapy = true;

  bool get arpWithScapy => _arpWithScapy;

  set arpWithScapy(bool val) {
    _arpWithScapy = val;
    notifyListeners();
  }

  bool _arpWithEtherCap = true;

  bool get arpWithEtherCap => _arpWithEtherCap;

  set arpWithEtherCap(bool val) {
    _arpWithEtherCap = val;
    notifyListeners();
  }

  bool masterButton = true;

  void startSnifing() {
    _socket.on("my_response", addVals);
    if (_socket.active) {
      _socket.emit("startSniffer", "start sniff");
    }
  }

  void stopSnifing() {
    if (_socket.active) {
      _socket.emit("stopSniffer", "stop sniff");
      logger.i("Sent request to stop");
    }
  }

  bool srcipupdate = false;
  bool dstipUpdate = false;
  bool get allipsAreUpdate => srcipupdate && dstipUpdate;
  dynamic addVals(dynamic data) {
    try {
      List<dynamic> tmps = data;
      // logger.d("got data--> $tmps");
      if (tmps.isNotEmpty) {
        vals.addAll(tmps.map((e) {
          return SnifferDataJsonModel.fromJson(json.decode(e));
        }));
        notifyListeners();
        Future.microtask((() {
          const jsonEncoder = JsonEncoder();
          List<SnifferDataJsonModel> tmp2 =
              tmps.map((e) => SnifferDataJsonModel.fromJson(json.decode(e))).toList();
          tmp2.forEach((e) {
            if (e.iP != null && e.iP?.dst != null) {
              // logger.d("Checking for ${snifferDataJsonModel.iP?.dst ?? ""} in lookup Table");
              if (!_ipLookUpTable.unqiueIpLookUpValues.contains(IPLookUpModel(ip: e.iP?.dst))) {
                // logger.d("found new ip ${snifferDataJsonModel.iP?.dst ?? ""}");
                _ipLookUpService.getIpLookUpData(e.iP?.dst ?? "");
              }
            }
            PacketModel model = PacketModel(
                dstip: e.iP != null ? e.iP!.dst : "",
                dstmac: e.ethernet != null ? e.ethernet!.dst : "",
                srcMac: e.ethernet != null ? e.ethernet!.src : "",
                srcip: e.iP != null ? e.iP!.src : "",
                rawData: jsonEncoder.convert(e).replaceAll("'", "\"").replaceAll('"', '\\"'),
                createddate: DateTime.now().toString());
            _packetTable.insertValue(model);
          });
        }));
      }
    } on Exception catch (e) {
      logger.e("onError --> ${e.toString()}");
    }
  }

  Future<void> scapyStartOrStop() async {
    if (arpWithScapy) {
      await _apiService.startARPPossingWithScapy().then((value) {
        if (value) {
          arpWithScapy = false;
        } else {
          logger.e("missing Src");
        }
      });
    } else {
      await _apiService.stopARPPossingWithScapy();
      arpWithScapy = true;
    }
    notifyListeners();
  }

  Future<void> checkAndStartArpWithEtherCap() async {
    if (arpWithEtherCap) {
      await _apiService.startArpWithEtherCap().then((value) {
        if (value) {
          arpWithEtherCap = false;
        } else {
          logger.e("missing Src");
        }
      });
    } else {
      await _apiService.stopArpWithEtherCap().then((value) {
        if (value) {
          arpWithEtherCap = true;
        } else {
          logger.e("missing Src");
        }
      });
    }
    notifyListeners();
  }

  void updateSrcIpandMac() {
    if (dst.realmac.isEmpty) {
      masterButton = false;
    }
    _apiService.setScrIpAndScrMac(src.ip, src.realmac);
    srcipupdate = true;
    notifyListeners();
  }

  void updateDstIpandMac() {
    if (dst.realmac.isEmpty) {
      masterButton = false;
    }
    dstipUpdate = true;
    _apiService.setDstIpAndDstMac(dst.ip, dst.realmac);
  }

  Future<List<IpWithMac>> getListOfIpWithMax() async {
    List<IpWithMac> ipWithMac = [];

    await _apiService.getHostIpWithMacCached().then((value) {
      for (Result element in value.results) {
        IpWithMac ip = IpWithMac(element.ipv4, element.mac);
        if (element.mac.isNotEmpty) ip.mac = element.mac;
        ipWithMac.add(ip);
      }
    });
    Future.microtask(() => _apiService.setIfaceName(iface: "eth0"));
    Future.microtask(() => _apiService.setDstIpAndDstMac(src.ip, src.mac));
    return ipWithMac;
  }

  bool _disposed = false;
  @override
  void dispose() async {
    try {
      if (_socket.connected) {
        stopSnifing();
      }
    } catch (e) {
      logger.e("OnError --> $e");
    }
    _disposed = true;
    scrollController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}

class IpWithMac {
  String ip;
  String mac;
  String realmac;
  IpWithMac(this.ip, this.realmac, {this.mac = "00.00.00.00.00"});
  @override
  String toString() {
    return "$ip->$mac";
  }
}
