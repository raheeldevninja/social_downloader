import 'package:dio/dio.dart';
import 'package:social_downloader/core/utils/app_constants.dart';


const String _contentType = "Content-Type";
const String _applicationJson = "application/json";
const String _apiKey = "1e2d328129msha49fca00df6f881p147af8jsne121c53deae6";
const String _apiHost = "tiktok-download-without-watermark.p.rapidapi.com";

class DioHelper {
  final Dio dio;

  DioHelper({required this.dio}) {
    Map<String, dynamic> headers = {
      _contentType: _applicationJson,
      "X-RapidAPI-Key": _apiKey,
      "X-RapidAPI-Host": _apiHost,
    };
    dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      receiveDataWhenStatusError: true,
      headers: headers,
    );
  }

  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParams,
  }) async {
    return await dio.get(path, queryParameters: queryParams);
  }

  Future<Response> download({
    required String downloadLink,
    required String savePath,
    Map<String, dynamic>? queryParams,
  }) async {
    return await dio.download(downloadLink, savePath);
  }
}
