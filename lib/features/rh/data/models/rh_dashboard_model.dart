class RhDashboardModel {
  final List<AprobacionPendiente> aprobaciones;
  final EstadoUltimaSolicitud? ultimaSolicitud;
  final ResumenPeriodo resumen;

  RhDashboardModel({
    required this.aprobaciones,
    this.ultimaSolicitud,
    required this.resumen,
  });

  factory RhDashboardModel.fromJson(Map<String, dynamic> json) {
    return RhDashboardModel(
      aprobaciones: (json['aprobaciones_pendientes'] as List? ?? [])
          .map((item) => AprobacionPendiente.fromJson(item))
          .toList(),
      ultimaSolicitud: json['estado_ultima_solicitud'] != null
          ? EstadoUltimaSolicitud.fromJson(json['estado_ultima_solicitud'])
          : null,
      resumen: ResumenPeriodo.fromJson(json['resumen_periodo'] ?? {}),
    );
  }
}

class AprobacionPendiente {
  final int id;
  final String nombre;
  final String fechaInicio;
  final String fechaFin;
  final String estado;

  AprobacionPendiente({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
  });

  factory AprobacionPendiente.fromJson(Map<String, dynamic> json) {
    return AprobacionPendiente(
      id: json['idAprobacion'] ?? 0,
      nombre: json['nombre_solicitante'] ?? 'Sin nombre',
      fechaInicio: json['fechaInicio'] ?? '',
      fechaFin: json['fechaFin'] ?? '',
      estado: json['estadoAprobacion'] ?? 'Pendiente',
    );
  }
}

class EstadoUltimaSolicitud {
  final int idSolicitud;
  final List<EstadoDetalle> estados;

  EstadoUltimaSolicitud({required this.idSolicitud, required this.estados});

  factory EstadoUltimaSolicitud.fromJson(Map<String, dynamic> json) {
    return EstadoUltimaSolicitud(
      idSolicitud: json['idSolicitud'] ?? 0,
      estados: (json['estados'] as List? ?? [])
          .map((item) => EstadoDetalle.fromJson(item))
          .toList(),
    );
  }
}

class EstadoDetalle {
  final String nombre;
  final bool actual;
  final bool pasado;

  EstadoDetalle({
    required this.nombre,
    required this.actual,
    required this.pasado,
  });

  factory EstadoDetalle.fromJson(Map<String, dynamic> json) {
    return EstadoDetalle(
      nombre: json['estado'] ?? '',
      actual: json['actual'] ?? false,
      pasado: json['pasado'] ?? false,
    );
  }
}

class ResumenPeriodo {
  final int pendientes, totales, usados;
  final String periodo;
  ResumenPeriodo({
    required this.pendientes,
    required this.totales,
    required this.usados,
    required this.periodo,
  });

  factory ResumenPeriodo.fromJson(Map<String, dynamic> json) {
    return ResumenPeriodo(
      pendientes: json['dias_pendientes'] ?? 0,
      totales: json['dias_totales'] ?? 0,
      usados: json['dias_usados'] ?? 0,
      periodo: json['periodo'] ?? 'Periodo no definido',
    );
  }

  double get porcentajeProgreso => totales > 0 ? (usados / totales) : 0.0;
}
