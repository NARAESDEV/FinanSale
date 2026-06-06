import '../../data/models/solicitud_item_model.dart';

abstract class SolicitudesState {}

class SolicitudesLoading extends SolicitudesState {}

class SolicitudesError extends SolicitudesState {
  final String message;
  SolicitudesError(this.message);
}

class SolicitudesLoaded extends SolicitudesState {
  final List<SolicitudItem> solicitudes;
  final Map<String, dynamic> resumen;
  SolicitudesLoaded(this.solicitudes, {this.resumen = const {}});
}

class SolicitudCreadaExito extends SolicitudesState {}

class SolicitudEditadaExito extends SolicitudesState {}
