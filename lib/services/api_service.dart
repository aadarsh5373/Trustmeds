import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // For Android emulator it's 10.0.2.2, for iOS simulator it's localhost
  // Update this to your production backend URL later
  final String baseUrl = 'http://127.0.0.1:8000/api/v1';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Automatically inject the JWT token into every request
        final token = await _secureStorage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Handle token expiration/unauthorized access globally (e.g., redirect to login)
          await _secureStorage.delete(key: 'jwt_token');
        }
        return handler.next(e);
      },
    ));
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'jwt_token');
  }

  Dio get client => _dio;
}
