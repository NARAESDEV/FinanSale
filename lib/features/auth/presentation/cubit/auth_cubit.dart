import 'package:finansale/core/utils/error_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthError("Por favor, llena todos los campos"));
      return;
    }

    emit(AuthLoading());

    try {
      final user = await _repository.login(email, password);
      // ¡ÉXITO! Emitimos el estado con todos los permisos del JSON
      emit(AuthAuthenticated(user));
    } catch (e) {
      final friendlyMessage = ErrorMapper.translate(e);
      emit(AuthError(friendlyMessage));
    }
  }

  void logout() {
    // Emitimos el estado inicial para que el router sepa que ya no estamos autenticados
    emit(AuthInitial());
  }
}
