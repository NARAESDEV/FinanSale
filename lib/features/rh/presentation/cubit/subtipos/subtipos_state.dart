import '../../../data/models/subtipo_solicitud_model.dart';

abstract class SubtiposState {}

class SubtiposInitial extends SubtiposState {}

class SubtiposLoading extends SubtiposState {}

class SubtiposLoaded extends SubtiposState {
  final List<SubtipoSolicitudModel> subtipos;
  SubtiposLoaded(this.subtipos);
}

class SubtiposError extends SubtiposState {
  final String message;
  SubtiposError(this.message);
}
