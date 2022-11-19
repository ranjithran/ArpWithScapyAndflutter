import 'package:dio/dio.dart';
import 'package:frontend/constants/constants.dart';

class DioClient {
  Dio init() {
    Dio dio = Dio();
    // dio.options.baseUrl = "http://127.0.0.1:5000";
      dio.options.baseUrl = mainurl;
    return dio;
  }
}
