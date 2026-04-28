import 'package:flutter_bloc/flutter_bloc.dart';
import 'subtipos_state.dart';
import '../../../domain/repositories/rh_repository.dart';
import '../../../../auth/data/models/user_model.dart';

class SubtiposCubit extends Cubit<SubtiposState> {
  final RhRepository _repository;

  SubtiposCubit(this._repository) : super(SubtiposInitial());

  // AHORA PEDIMOS EL idTipoSolicitud COMO PARÁMETRO
  Future<void> fetchSubtipos(UserModel user, int idTipoSolicitud) async {
    try {
      emit(SubtiposLoading());

      // LLAMAMOS AL NUEVO MÉTODO DEL REPOSITORIO
      final lista = await _repository.getSubtiposPorTipo(user, idTipoSolicitud);

      emit(SubtiposLoaded(lista));
    } catch (e) {
      emit(SubtiposError(e.toString()));
    }
  }
}
