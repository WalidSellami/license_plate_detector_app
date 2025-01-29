import 'package:dio/dio.dart';
import 'package:license_plate_detector/shared/components/Constants.dart';

class DioHelper {

  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

  }


  static Future<Response?> getData({
    required String pathUrl,
}) async {

    return await dio?.get(pathUrl);

  }


  static Future<Response?> postData({
    required String pathUrl,
    required dynamic data
}) async{

    return await dio?.post(pathUrl, data:data);

  }

  static Future<Response?> putData({
    required String pathUrl,
    dynamic data
  }) async{

    return await dio?.put(pathUrl, data:data);

  }

  static Future<Response?> deleteData({
    required String pathUrl,
  }) async{

    return await dio?.delete(pathUrl);

  }



}