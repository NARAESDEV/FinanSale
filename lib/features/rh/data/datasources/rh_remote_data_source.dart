import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:finansale/features/rh/data/models/tipo_solicitud_model.dart';
import 'package:finansale/features/rh/data/models/usuario_sustitucion_model.dart';
import '../../../../core/network/dio_client.dart';
import '../models/subtipo_solicitud_model.dart';
// IMPORTA TU MODELO DE USUARIO
import '../../../auth/data/models/user_model.dart';

class RhRemoteDataSource {
  Dio get _dio => DioClient.instance;

  // Obtener la lista principal de Tipos
  Future<List<TipoSolicitudModel>> getTiposSolicitud(UserModel user) async {
    try {
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      final response = await _dio.get(
        '/tipo_solicitud/',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      List<dynamic> data = response.data;
      return data.map((json) => TipoSolicitudModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener los tipos de solicitud');
    }
  }

  // Obtener los Subtipos dependientes pasando el ID del Tipo
  Future<List<SubtipoSolicitudModel>> getSubtiposPorTipo(
    UserModel user,
    int idTipoSolicitud,
  ) async {
    try {
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      // Concatenamos el ID en la ruta como lo requiere tu backend
      final response = await _dio.get(
        '/subtipo_solicitud/$idTipoSolicitud',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      // Si el backend devuelve un solo objeto en lugar de un arreglo, lo envolvemos en una lista
      // Si devuelve un arreglo, mapeamos normalmente
      if (response.data is List) {
        List<dynamic> data = response.data;
        return data
            .map((json) => SubtipoSolicitudModel.fromJson(json))
            .toList();
      } else {
        return [SubtipoSolicitudModel.fromJson(response.data)];
      }
    } on DioException catch (e) {
      throw Exception('Error al obtener los subtipos');
    }
  }

  Future<List<UsuarioSustitucionModel>> getUsuariosSustitucion(
    UserModel user,
  ) async {
    try {
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      // Revisa si en tu backend real es 'dispobles' o 'disponibles'
      final response = await _dio.get(
        '/usuarios/dispobles_sustitucion',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      final List<dynamic> data = response.data['usuarios'] ?? [];
      return data
          .map((json) => UsuarioSustitucionModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      // ESTO IMPRIMIRÁ SI EL BACKEND DEVUELVE 404, 401, 500, etc.
      print(
        "🚨 ERROR DIO RESPONSABLES: Código ${e.response?.statusCode} - Respuesta: ${e.response?.data}",
      );
      throw Exception('Error del servidor: ${e.response?.statusCode}');
    } catch (e) {
      // ESTO IMPRIMIRÁ SI EL JSON VIENE DIFERENTE A LO ESPERADO
      print("🚨 ERROR DART RESPONSABLES (Mapeo de JSON): $e");
      throw Exception('Error al procesar el JSON de la base de datos');
    }
  }
}
