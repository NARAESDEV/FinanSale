import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;

  // Getter global para que los DataSources lo usen
  static Dio get instance => _instance._dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        // Sin baseUrl estática. Esperará a que el Cubit se la inyecte.
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );
  }

  // Método que el AuthCubit usa para inyectar la URL del Workspace
  static void setBaseUrl(String url) {
    _instance._dio.options.baseUrl = url;
  }
}
