import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/subtipo_solicitud_model.dart';
// IMPORTA TU MODELO DE USUARIO
import '../../../auth/data/models/user_model.dart';

class RhRemoteDataSource {
  Dio get _dio => DioClient.instance;

  // 1. AHORA PEDIMOS EL UserModel
  Future<List<SubtipoSolicitudModel>> getSubtiposSolicitud(
    UserModel user,
  ) async {
    try {
      // 2. CONSTRUIMOS EL HEADER BASIC AUTH
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      // 3. ENVIAMOS EL HEADER EN LA PETICIÓN
      final response = await _dio.get(
        '/solicitudes/subtipos/',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      List<dynamic> data = response.data;
      return data.map((json) => SubtipoSolicitudModel.fromJson(json)).toList();
    } on DioException catch (e) {
      String mensajeError = 'Error de conexión';
      if (e.response?.data != null && e.response!.data is Map) {
        mensajeError =
            e.response!.data['message'] ?? 'Error al obtener trámites';
      } else {
        mensajeError = "Servidor rechazó la conexión o usuario inválido.";
      }
      throw Exception(mensajeError);
    }
  }
}
