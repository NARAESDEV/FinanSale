import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/data/models/user_model.dart';
import '../../../domain/repositories/rh_repository.dart';
import '../../../data/models/tipo_solicitud_model.dart';

// --- ESTADOS ---
abstract class TiposState {}

class TiposInitial extends TiposState {}

class TiposLoading extends TiposState {}

class TiposLoaded extends TiposState {
  final List<TipoSolicitudModel> tipos;
  TiposLoaded(this.tipos);
}

class TiposError extends TiposState {
  final String message;
  TiposError(this.message);
}

class TiposCubit extends Cubit<TiposState> {
  final RhRepository _repository;

  TiposCubit(this._repository) : super(TiposInitial());

  Future<void> fetchTipos(UserModel user) async {
    emit(TiposLoading());
    try {
      final tipos = await _repository.getTiposSolicitud(user);
      emit(TiposLoaded(tipos));
    } catch (e) {
      emit(TiposError(e.toString()));
    }
  }
}
