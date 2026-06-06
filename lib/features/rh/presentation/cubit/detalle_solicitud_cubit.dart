import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/detalle_solicitud_model.dart';
import 'detalle_solicitud_state.dart';

class DetalleSolicitudCubit extends Cubit<DetalleSolicitudState> {
  final Dio _dio = DioClient.instance;

  DetalleSolicitudCubit() : super(DetalleSolicitudLoading());

  Future<void> getDetalleSolicitud(UserModel user, int idSolicitud) async {
    try {
      emit(DetalleSolicitudLoading());
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      final response = await _dio.get(
        '/solicitudes/$idSolicitud', // Con trailing slash reglamentario
        options: Options(headers: {'Authorization': basicAuth}),
      );

      final detalle = DetalleSolicitudModel.fromJson(response.data);
      emit(DetalleSolicitudLoaded(detalle));
    } catch (e) {
      emit(DetalleSolicitudError(ErrorMapper.translate(e)));
    }
  }
}
