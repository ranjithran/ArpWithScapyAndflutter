import 'package:dio/dio.dart';
import 'package:frontend/Core/JsonModel/nmap_with_ip_mac.dart';
import 'package:frontend/locator.dart';

class ApiService {
  final Dio http = locator.get<Dio>();

  List<String> _ifaces = [];

  HostsWithMac get hostsWithMac {
    if (_hostsWithMac == null) {
      getHostIpWithMacCached();
      return _hostsWithMac!;
    } else {
      return _hostsWithMac!;
    }
  }

  HostsWithMac? _hostsWithMac;
  

  Future<List<String>> getIfaces() async {
    if (_ifaces.isEmpty) {
      await http.get("/getIfNames").then((value) {
        _ifaces = List<String>.from(value.data);
        return _ifaces;
      }).catchError((onError) {
        logger.e(onError);
      });
      logger.d("values recevied from api for /getIfNames $_ifaces");
    }
    return _ifaces;
  }

  Future<HostsWithMac> getHostIpWithMacCached() async {
    if (_hostsWithMac == null) {
      await http.get("/getHostsMacscache?ip=192.168.1.1").then((value) {
        _hostsWithMac = hostsWithMacFromJson(value.data.toString());
        logger.d("values recevied from api for /getIfNames $_hostsWithMac");
      });
    }
    return hostsWithMac;
  }

  Future<HostsWithMac> getHostIpWithMac() async {
    if (_hostsWithMac != null) {
      _hostsWithMac = null;
    }
    await http.get("/getHostsMacs?ip=192.168.1.1").then((value) {
      _hostsWithMac = hostsWithMacFromJson(value.data.toString());
      logger.d("values recevied from api for /getIfNames $_hostsWithMac");
      return hostsWithMac;
    });
    return hostsWithMac;
  }

  Future<String> setScrIpAndScrMac(String ip, String mac) async {
    String result = "";
    await http.get("/setSrcIpandMac?srcIp=$ip&srcMac=$mac").then((value) {
      result = value.data;
    });
    return result;
  }

  Future<String> setDstIpAndDstMac(String ip, String mac) async {
    String result = "";
    await http.get("/setDrcIpandMac?dstIp=$ip&dstMac=$mac").then((value) {
      result = value.data;
    });
    return result;
  }

  Future<String> setIfaceName({String iface = "eth0"}) async {
    String result = "";
    await http.get("/setIFace?iface=$iface").then((value) {
      logger.d("Updated Server with iface name as $iface");
      result = value.data;
    });
    return result;
  }

  Future<bool> startARPPossingWithScapy() async {
    bool status = false;
    await http.get("/startArpWithScapy").then((value) {
      if (value.statusCode == 200) {
        logger.d("Strated Succefully");
        status = true;
      } else {
        logger.e("Statuscode issue ");
      }
    });
    return status;
  }

  Future<bool> stopARPPossingWithScapy() async {
    await http.get("/stopArpWithScapy").then((value) {
      if (value.statusCode == 200) {
        logger.d("Strated Succefully");
        return true;
      }
    });
    return false;
  }

  Future<bool> startArpWithEtherCap() async {
    bool status = false;
    await http.get("/startArpWithEtherCap").then((value) {
      if (value.statusCode == 200) {
        logger.d("Strated Succefully");
        status = true;
      } else if (value.statusCode == 500) {
        logger.d("Not Strated");
        status = false;
      }
    }).catchError((error) {
      DioError e = error as DioError;
      if (e.response!.statusCode == 500) {
        logger.e(e.response);
        status = false;
      }
    });
    return status;
  }

  Future<bool> stopArpWithEtherCap() async {
    bool status = false;
    await http.get("/stopArpWithEtherCap").then((value) {
      if (value.statusCode == 200) {
        logger.d("Strated Succefully");
        status = true;
      } else if (value.statusCode == 500) {
        logger.d("Not Strated");
        status = false;
      }
    }).catchError((error) {
      DioError e = error as DioError;
      if (e.response!.statusCode == 500) {
        logger.e(e.response);
        status = false;
      }
    });
    return status;
  }

  Future<dynamic> getServerData() async {
    dynamic val = "";
    await http.get("/getServerData").then((value) {
      val = value.toString();
    }).catchError((onError) {
      logger.e("onError->$onError");
    });
    return val;
  }
}
