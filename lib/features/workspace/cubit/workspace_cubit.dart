import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/services/storage_service.dart';
import 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit() : super(WorkspaceInitial());

  Future<void> connectToWorkspace(String url) async {
    try {
      emit(WorkspaceLoading());

      final cleanUrl = url.trim().endsWith('/') ? url.trim() : '${url.trim()}/';
      final testDio = Dio(
        BaseOptions(connectTimeout: const Duration(seconds: 5)),
      );
      final response = await testDio.get(cleanUrl);

      if (response.statusCode != null) {
        DioClient.setBaseUrl(cleanUrl);

        await StorageService.instance.saveWorkspace(cleanUrl);

        emit(WorkspaceSuccess());
      } else {
        emit(WorkspaceError("Respuesta inválida del servidor."));
      }
    } catch (e) {
      emit(
        WorkspaceError(
          "No se pudo conectar. Verifica la URL o tu conexión a internet.",
        ),
      );
    }
  }
}
