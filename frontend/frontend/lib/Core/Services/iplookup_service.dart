import 'package:dio/dio.dart';
import 'package:frontend/Core/Db/ip_look_up.dart';
import 'package:frontend/locator.dart';

class IpLookUpService {
  final Dio _dio = Dio();
  final IpLookUpTable _ipLookUpTable = locator.get<IpLookUpTable>();

  Future getIpLookUpData(String ip) async {
    await _dio
        .get("http://ipinfo.io/$ip", options: Options(headers: {"User-Agent": "curl/7.81.0"}))
        .then((value) {
      if (!_ipLookUpTable.unqiueIpLookUpValues.contains(ip)) {
        IPLookUpModel ipLookUpModel = IPLookUpModel.fromJson(value.data);
        // logger.d(ipLookUpModel.toString());
        _ipLookUpTable.insertData(ipLookUpModel);
      }
    }).catchError((onError) {
      logger.e("$onError");
    });
  }
}
