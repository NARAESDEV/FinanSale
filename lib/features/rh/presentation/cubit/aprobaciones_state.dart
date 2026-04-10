import '../../data/models/rh_dashboard_model.dart';

abstract class AprobacionesState {}

class AprobacionesLoading extends AprobacionesState {}

class AprobacionesLoaded extends AprobacionesState {
  final List<AprobacionPendiente> aprobaciones;
  AprobacionesLoaded(this.aprobaciones);
}

class AprobacionesError extends AprobacionesState {
  final String message;
  AprobacionesError(this.message);
}
