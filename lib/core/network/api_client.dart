import 'package:dio/dio.dart';
import 'cronet_adapter.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com/', // Placeholder
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    // Use Cronet on Android, standard adapter otherwise
    if (defaultTargetPlatform == TargetPlatform.android) {
        // We use our custom adapter
        _dio.httpClientAdapter = CronetAdapter();
    }
  }

  Dio get dio => _dio;
}
