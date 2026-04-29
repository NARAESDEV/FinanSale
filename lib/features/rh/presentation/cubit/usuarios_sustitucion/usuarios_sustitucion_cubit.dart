import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/data/models/user_model.dart';
import '../../../domain/repositories/rh_repository.dart';
import '../../../data/models/usuario_sustitucion_model.dart';

abstract class UsuariosSustitucionState {}

class UsuariosSustitucionInitial extends UsuariosSustitucionState {}

class UsuariosSustitucionLoading extends UsuariosSustitucionState {}

class UsuariosSustitucionLoaded extends UsuariosSustitucionState {
  final List<UsuarioSustitucionModel> lista;

  UsuariosSustitucionLoaded(this.lista);
}

class UsuariosSustitucionError extends UsuariosSustitucionState {
  final String message;

  UsuariosSustitucionError(this.message);
}

class UsuariosSustitucionCubit extends Cubit<UsuariosSustitucionState> {
  final RhRepository _repository;

  UsuariosSustitucionCubit(this._repository)
    : super(UsuariosSustitucionInitial());

  Future<void> fetchUsuarios(UserModel user) async {
    emit(UsuariosSustitucionLoading());
    try {
      // Disparamos la petición al backend
      final lista = await _repository.getUsuariosSustitucion(user);

      // Emitimos el estado de éxito con la lista llena
      emit(UsuariosSustitucionLoaded(lista));
    } catch (e) {
      // Si falla, emitimos el error
      emit(UsuariosSustitucionError(e.toString()));
    }
  }
}
