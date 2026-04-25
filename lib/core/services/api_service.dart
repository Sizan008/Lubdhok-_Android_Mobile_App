import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lubdhok/core/config/api_endpoints.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 80),
        receiveTimeout: const Duration(seconds: 80),
        sendTimeout: const Duration(seconds: 80),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            final token = await user.getIdToken(true);

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            if (user.email != null) {
              options.headers['X-User-Email'] = user.email!;
            }
          }

          debugPrint('API => ${options.method} ${options.uri}');
          debugPrint('DATA => ${options.data}');
          handler.next(options);
        },
        onError: (e, handler) {
          debugPrint(
            'API ERROR => status=${e.response?.statusCode}, data=${e.response?.data}',
          );
          handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return dio.put(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) async {
    return dio.patch(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return dio.delete(path, data: data);
  }
}