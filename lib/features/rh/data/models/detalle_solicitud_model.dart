class DetalleSolicitudModel {
  final int idSolicitud;
  final String tipoSolicitud;
  final String nombreSolicitante;
  final String nombreResponsable;
  final String fechaInicio;
  final String fechaFin;
  final int diasTotalesVacaciones;
  final List<CambioHistorialModel> historialCambios;

  DetalleSolicitudModel({
    required this.idSolicitud,
    required this.tipoSolicitud,
    required this.nombreSolicitante,
    required this.nombreResponsable,
    required this.fechaInicio,
    required this.fechaFin,
    required this.diasTotalesVacaciones,
    required this.historialCambios,
  });

  factory DetalleSolicitudModel.fromJson(Map<String, dynamic> json) {
    // 1. Extraemos de forma segura el nombre del responsable desde el nuevo arreglo
    String responsable = 'Sin asignar';
    if (json['responsables'] != null &&
        (json['responsables'] as List).isNotEmpty) {
      responsable =
          json['responsables'][0]['nombre_responsable'] ?? 'Sin asignar';
    }

    final List<dynamic> rawList =
        json['historial_cambios_estados'] as List<dynamic>? ?? [];
    final List<CambioHistorialModel> historial = rawList
        .map(
          (item) => CambioHistorialModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();

    return DetalleSolicitudModel(
      idSolicitud: json['idSolicitud'] ?? 0,
      tipoSolicitud: json['tipoSolicitud'] ?? 'Trámite',
      nombreSolicitante: json['nombre_solicitante'] ?? 'Sin nombre',
      nombreResponsable:
          responsable, // <--- Pasamos la variable procesada arriba
      fechaInicio: json['fechaInicio'] ?? '',
      fechaFin: json['fechaFin'] ?? '',
      diasTotalesVacaciones: json['diasTotalesVacaciones'] ?? 0,
      historialCambios: historial,
    );
  }
}

class CambioHistorialModel {
  final String estado;
  final bool actual;
  final bool pasado;

  CambioHistorialModel({
    required this.estado,
    required this.actual,
    required this.pasado,
  });

  factory CambioHistorialModel.fromJson(Map<String, dynamic> json) {
    return CambioHistorialModel(
      estado: json['estado'] ?? 'Desconocido',
      actual: json['actual'] ?? false,
      pasado: json['pasado'] ?? false,
    );
  }
}
