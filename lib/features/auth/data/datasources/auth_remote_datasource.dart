import 'dart:convert'; // Este es el que faltaba para el encode
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  static String get baseUrl {
    return dotenv.env['API_URL'] ?? 
        (Platform.isAndroid ? 'http://10.0.2.2:5000' : 'http://127.0.0.1:5000');
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
    ),
  );

  Future<UserModel> login(String correo, String password) async {
    try {
      // Generamos el string de Basic Auth antes de la petición
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$correo:$password'))}';

      final response = await _dio.post(
        '/login',
        data: {'correo': correo, 'contrasena': password},
        // Aquí es donde le pasamos el header que te está pidiendo el back
        options: Options(headers: {'Authorization': basicAuth}),
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print("Error Dio [${e.type}]: ${e.message}");
      if (e.response != null) {
        print("Data error del servidor: ${e.response?.data}");
      }
      throw Exception(e.response?.data['message'] ?? 'Fallo en el servidor');
    }
  }
}
