import '../../data/models/detalle_solicitud_model.dart';

abstract class DetalleSolicitudState {}

class DetalleSolicitudLoading extends DetalleSolicitudState {}

class DetalleSolicitudLoaded extends DetalleSolicitudState {
  final DetalleSolicitudModel detalle;
  DetalleSolicitudLoaded(this.detalle);
}

class DetalleSolicitudError extends DetalleSolicitudState {
  final String message;
  DetalleSolicitudError(this.message);
}
