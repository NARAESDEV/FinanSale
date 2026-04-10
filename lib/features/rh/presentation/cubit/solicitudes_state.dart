import '../../data/models/solicitud_item_model.dart';

abstract class SolicitudesState {}

class SolicitudesLoading extends SolicitudesState {}

class SolicitudesLoaded extends SolicitudesState {
  final List<SolicitudItem> solicitudes;
  SolicitudesLoaded(this.solicitudes);
}

class SolicitudesError extends SolicitudesState {
  final String message;
  SolicitudesError(this.message);
}
