import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/rh_dashboard_model.dart';
import 'aprobaciones_state.dart';

class AprobacionesCubit extends Cubit<AprobacionesState> {
  final Dio _dio = DioClient.instance;

  AprobacionesCubit() : super(AprobacionesLoading());

  Future<void> getListaAprobaciones(UserModel user) async {
    try {
      emit(AprobacionesLoading());

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      // El endpoint devuelve un arreglo directo [ { ... }, { ... } ]
      final response = await _dio.get(
        '/aprobaciones/pendientes',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      // Mapeamos la lista de JSON a nuestra lista de objetos
      final List<dynamic> data = response.data;
      final lista = data
          .map((item) => AprobacionPendiente.fromJson(item))
          .toList();

      emit(AprobacionesLoaded(lista));
    } catch (e) {
      emit(AprobacionesError(ErrorMapper.translate(e)));
    }
  }
}
