import 'dart:convert';
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
}
