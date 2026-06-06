class SolicitudItem {
  final int id;
  final String nombre;
  final String tipoSolicitud;
  final String fechaInicio;
  final String fechaFin;
  final String estado;
  final String nombreSustituto;

  SolicitudItem({
    required this.id,
    required this.nombre,
    required this.tipoSolicitud,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    required this.nombreSustituto,
  });

  // Aceptamos Map opcional (?) para evitar que truene si el objeto entero es null
  factory SolicitudItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SolicitudItem(
        id: 0,
        tipoSolicitud: 'Desconocido',
        nombre: 'Sin nombre',
        fechaInicio: '',
        fechaFin: '',
        estado: 'Pendiente',
        nombreSustituto: 'Sin sustituto',
      );
    }

    return SolicitudItem(
      id: json['idSolicitud'] is int
          ? json['idSolicitud']
          : (int.tryParse(json['idSolicitud']?.toString() ?? '') ?? 0),

      // Forzamos .toString() antes del fallback para destruir cualquier valor 'Null' real
      tipoSolicitud: json['tipoSolicitud']?.toString() ?? 'Desconocido',
      nombre: json['nombre_solicitante']?.toString() ?? 'Sin nombre',
      fechaInicio: json['fechaInicio']?.toString() ?? '',
      fechaFin: json['fechaFin']?.toString() ?? '',
      estado: json['estadoSolicitud']?.toString() ?? 'Pendiente',
      nombreSustituto:
          json['nombre_sustituto']?.toString() ?? 'Sin sustituto asignado',
    );
  }
}
