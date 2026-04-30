import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/solicitud_item_model.dart';
import 'solicitudes_state.dart';

class SolicitudesCubit extends Cubit<SolicitudesState> {
  final Dio _dio = DioClient.instance;

  SolicitudesCubit() : super(SolicitudesLoading());

  Future<void> getMisSolicitudes(UserModel user) async {
    try {
      emit(SolicitudesLoading());

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      final response = await _dio.get(
        '/solicitudes/',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      // OJO AQUÍ: Extraemos el arreglo que viene dentro de la llave "solicitudes"
      final List<dynamic> data = response.data['solicitudes'] ?? [];
      final Map<String, dynamic> resumen =
          response.data['resumen_periodo'] ?? {};
      final lista = data.map((item) => SolicitudItem.fromJson(item)).toList();

      emit(SolicitudesLoaded(lista, resumen: resumen));
    } catch (e) {
      emit(SolicitudesError(ErrorMapper.translate(e)));
    }
  }

  Future<void> crearSolicitud({
    required UserModel user,
    required String fechaInicio,
    required String fechaFin,
    required int idTipoSolicitud,
    File? archivoAdjunto,
    String? idUsuarioSustituto,
    String? nombreAdjunto,
    String? tamanioAdjunto,
    String? adjuntoBase64,
  }) async {
    try {
      emit(SolicitudesLoading());

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      final payload = {
        "fechaInicio": fechaInicio,
        "fechaFin": fechaFin,
        "idTipoSolicitud": idTipoSolicitud,
        "idUsuarioSustituto": idUsuarioSustituto,
      };

      if (idUsuarioSustituto != null) {
        payload["idUsuarioSustituto"] = idUsuarioSustituto;
      }

      if (adjuntoBase64 != null && nombreAdjunto != null) {
        payload["nombreAdjunto"] = nombreAdjunto;
        payload["tamanioAdjunto"] = tamanioAdjunto;
        payload["adjunto"] =
            adjuntoBase64; // <-- La llave que espera tu backend
      }

      print("🚀 PAYLOAD A ENVIAR: $payload");

      await _dio.post(
        '/solicitudes/',
        data: payload,
        options: Options(headers: {'Authorization': basicAuth}),
      );

      emit(SolicitudCreadaExito());
    } catch (e) {
      emit(SolicitudesError("Error al crear la solicitud"));
    }
  }

  // --- MÉTODO PUT/PATCH: EDITAR SOLICITUD ---
  Future<void> editarSolicitud({
    required UserModel user,
    required int idSolicitudAEditar,
    required String fechaInicio,
    required String fechaFin,
  }) async {
    try {
      emit(SolicitudesLoading());

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      final payload = {"fechaInicio": fechaInicio, "fechaFin": fechaFin};

      await _dio.put(
        '/solicitudes/$idSolicitudAEditar',
        data: payload,
        options: Options(headers: {'Authorization': basicAuth}),
      );

      emit(SolicitudEditadaExito());
    } catch (e) {
      emit(SolicitudesError("Error al editar la solicitud"));
    }
  }
}
