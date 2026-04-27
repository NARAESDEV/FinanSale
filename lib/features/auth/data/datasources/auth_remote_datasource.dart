import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

import '../../../../core/network/dio_client.dart';

class AuthRemoteDataSource {
  Dio get _dio => DioClient.instance;

  Future<UserModel> login(String correo, String password) async {
    try {
      // Generamos el string de Basic Auth antes de la petición
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$correo:$password'))}';
      print("========= AUDITORÍA DE RED =========");
      print("URL Base configurada en Dio: ${_dio.options.baseUrl}");
      print("Haciendo POST a: ${_dio.options.baseUrl}/login");
      print("====================================");
      final response = await _dio.post(
        '/login',
        data: {'correo': correo, 'contrasena': password},
        options: Options(headers: {'Authorization': basicAuth}),
      );

      final userModel = UserModel.fromJson(response.data);
      userModel.contrasena = password;
      return userModel;
    } on DioException catch (e) {
      print("Error Dio [${e.type}]: ${e.message}");
      if (e.response != null) {
        print("Data error del servidor: ${e.response?.data}");
      }
      throw Exception(e.response?.data['message'] ?? 'Fallo en el servidor');
    }
  }
}
