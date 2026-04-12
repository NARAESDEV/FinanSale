import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../auth/data/models/user_model.dart';
import 'package:finansale/features/hub/data/model/perfil_model.dart';
import 'perfil_state.dart';

class PerfilCubit extends Cubit<PerfilState> {
  final Dio _dio = DioClient.instance;

  PerfilCubit() : super(PerfilLoading());

  Future<void> getPerfilUsuario(UserModel user) async {
    try {
      emit(PerfilLoading());

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('${user.correo}:${user.contrasena}'))}';

      // RIESGO: Verifica que tu UserModel tenga la propiedad 'idUsuario' o ajustala aquí
      final String idUsuario = user.idUsuario ?? 'USU0000001';

      final response = await _dio.get(
        '/usuarios/detalles/$idUsuario',
        options: Options(headers: {'Authorization': basicAuth}),
      );

      final perfil = PerfilModel.fromJson(response.data);
      emit(PerfilLoaded(perfil));
    } catch (e) {
      emit(PerfilError(ErrorMapper.translate(e)));
    }
  }
}
