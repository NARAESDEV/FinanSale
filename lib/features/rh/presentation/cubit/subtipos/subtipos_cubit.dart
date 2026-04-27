import 'package:flutter_bloc/flutter_bloc.dart';
import 'subtipos_state.dart';
import '../../../domain/repositories/rh_repository.dart';
// IMPORTA EL MODELO
import '../../../../auth/data/models/user_model.dart';

class SubtiposCubit extends Cubit<SubtiposState> {
  final RhRepository _repository;

  SubtiposCubit(this._repository) : super(SubtiposInitial());

  // RECIBIMOS AL USUARIO AQUÍ
  Future<void> fetchSubtipos(UserModel user) async {
    try {
      emit(SubtiposLoading());
      // SE LO PASAMOS AL REPO
      final lista = await _repository.getSubtiposSolicitud(user);
      emit(SubtiposLoaded(lista));
    } catch (e) {
      emit(SubtiposError(e.toString()));
    }
  }
}
