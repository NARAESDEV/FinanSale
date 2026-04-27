import 'package:finansale/core/utils/error_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

// --- NUEVOS IMPORTS PARA WORKSPACE ---
import '../../../../core/network/dio_client.dart';
import '../../../../shared/services/storage_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  // 1. CAMBIO: Usamos llaves {} para parámetros nombrados (coincide con la UI)
  Future<void> login({
    required String url,
    required String email,
    required String password,
  }) async {
    // Validación de seguridad inicial
    if (url.isEmpty || email.isEmpty || password.isEmpty) {
      emit(AuthError("Por favor, llena todos los campos"));
      return;
    }

    emit(AuthLoading());

    try {
      // 2. CONFIGURACIÓN DINÁMICA: Limpiamos la URL y la inyectamos a Dio
      // final cleanUrl = url.trim().endsWith('/') ? url.trim() : '${url.trim()}/';
      final cleanUrl = url.trim().endsWith('/')
          ? url.trim().substring(0, url.trim().length - 1)
          : url.trim();
      DioClient.setBaseUrl(cleanUrl);

      // 3. PETICIÓN AL BACKEND: Pasa por el repositorio que ya tienes
      final user = await _repository.login(email, password);

      // 4. PERSISTENCIA SEGURA: Solo si el repositorio no lanzó error (200 OK),
      // guardamos la URL en SQLite. Si la IP era falsa o la contraseña mala, no llega aquí.
      await StorageService.instance.saveWorkspace(cleanUrl);

      // ¡ÉXITO! Emitimos el estado con todos los permisos del JSON
      emit(AuthAuthenticated(user));
    } catch (e) {
      // Si entra aquí, puede ser porque el correo/pass están mal, o porque
      // la URL que ingresaron no existe (Timeout). El ErrorMapper lo traducirá.
      final friendlyMessage = ErrorMapper.translate(e);
      emit(AuthError(friendlyMessage));
    }
  }

  void logout() {
    // Emitimos el estado inicial para que el router sepa que ya no estamos autenticados
    emit(AuthInitial());
  }
}
