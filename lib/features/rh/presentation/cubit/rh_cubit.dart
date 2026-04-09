import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/error_mapper.dart';
import 'package:finansale/features/auth/data/models/user_model.dart';
import '../../data/models/rh_dashboard_model.dart';
import 'rh_state.dart';

class RhCubit extends Cubit<RhState> {
  final Dio _dio = DioClient.instance;

  RhCubit() : super(RhLoading());

  Future<void> getDashboardData(UserModel user) async {
    try {
      emit(RhLoading());
      
      // Construimos el basic auth con los datos del usuario logueado
      final String basicAuth = 'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      final response = await _dio.get(
        'aprobaciones/movil/inicio',
        options: Options(headers: {'Authorization': basicAuth}),
      );
      final data = RhDashboardModel.fromJson(response.data);
      emit(RhLoaded(data));
    } catch (e) {
      emit(RhError(ErrorMapper.translate(e)));
    }
  }
}
