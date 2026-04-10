class SolicitudItem {
  final int id;
  final String nombre;
  final String fechaInicio;
  final String fechaFin;
  final String estado;

  SolicitudItem({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
  });

  factory SolicitudItem.fromJson(Map<String, dynamic> json) {
    return SolicitudItem(
      id: json['idSolicitud'] ?? 0,
      nombre: json['nombre_solicitante'] ?? 'Sin nombre',
      fechaInicio: json['fechaInicio'] ?? '',
      fechaFin: json['fechaFin'] ?? '',
      estado: json['estadoSolicitud'] ?? 'Pendiente',
    );
  }
}
