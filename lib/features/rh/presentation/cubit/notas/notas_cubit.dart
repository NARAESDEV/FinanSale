import 'dart:convert';
import 'package:finansale/core/network/dio_client.dart';
import 'package:finansale/core/utils/error_mapper.dart';
import 'package:finansale/features/auth/data/models/user_model.dart';
import 'package:finansale/features/rh/data/models/notas/nota_solicitud_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'notas_state.dart';

class NotasCubit extends Cubit<NotasState> {
  final Dio _dio = DioClient.instance;

  NotasCubit() : super(NotasInitial());

  // 💬 OBTENER HISTORIAL DE NOTAS (GET)
  Future<void> getNotasSolicitud(UserModel user, int idSolicitud) async {
    try {
      emit(NotasLoading());
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      final response = await _dio.get(
        '/notas_solicitudes/$idSolicitud', // Endpoint exacto de tu Flask
        options: Options(headers: {'Authorization': basicAuth}),
      );

      // Mapeamos el listado dinámico devuelto por el servidor
      final List<dynamic> data = response.data is List ? response.data : [];
      final notas = data
          .map((item) => NotaSolicitudModel.fromJson(item))
          .toList();

      emit(NotasLoaded(notas));
    } catch (e) {
      emit(NotasError(ErrorMapper.translate(e)));
    }
  }

  Future<void> enviarNota({
    required UserModel user,
    required int idSolicitud,
    required String contenido,
    String? nombreAdjunto,
    String? tamanioAdjunto,
    String? adjuntoBase64,
  }) async {
    try {
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      // Construimos el payload con las llaves exactas que especificaste
      final Map<String, dynamic> payload = {
        "nota": contenido,
        "idSolicitud": idSolicitud,
        "nombreAdjunto": nombreAdjunto,
        "tamanioAdjunto": tamanioAdjunto,
        "adjunto": adjuntoBase64,
      };

      await _dio.post(
        '/notas_solicitudes/',
        data: payload,
        options: Options(headers: {'Authorization': basicAuth}),
      );

      emit(NotaEnviadaExito());
    } catch (e) {
      emit(NotasError("No se pudo registrar la nota en la bitácora"));
    }
  }

  // 🗑️ NUEVO MÉTODO CENTRALIZADO: ELIMINAR NOTA (DELETE)
  Future<void> eliminarNota(UserModel user, int idNota) async {
    try {
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      await _dio.delete(
        '/notas_solicitudes/$idNota', // Endpoint exacto de eliminación
        options: Options(headers: {'Authorization': basicAuth}),
      );

      emit(NotaEliminadaExito()); // Notifica el éxito del borrado
    } catch (e) {
      emit(NotasError("Error al intentar eliminar el mensaje seleccionado"));
    }
  }
}
