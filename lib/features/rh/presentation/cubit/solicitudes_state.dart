import '../../data/models/solicitud_item_model.dart';

abstract class SolicitudesState {}

class SolicitudesLoading extends SolicitudesState {}

// class SolicitudesLoaded extends SolicitudesState {
//   final List<SolicitudItem> solicitudes;
//   SolicitudesLoaded(this.solicitudes);
// }

class SolicitudesError extends SolicitudesState {
  final String message;
  SolicitudesError(this.message);
}

class SolicitudesLoaded extends SolicitudesState {
  final List<SolicitudItem> solicitudes;
  final Map<String, dynamic> resumen;
  // El valor por defecto asegura que el resto de tu app no explote
  SolicitudesLoaded(this.solicitudes, {this.resumen = const {}});
}

// ... tus estados anteriores (SolicitudesInitial, SolicitudesLoading, SolicitudesLoaded, etc.)

class SolicitudCreadaExito extends SolicitudesState {
  // Puedes agregar propiedades aquí en el futuro si necesitas pasar un mensaje
  // final String mensaje;
  // SolicitudCreadaExito(this.mensaje);
}

class SolicitudEditadaExito extends SolicitudesState {}
