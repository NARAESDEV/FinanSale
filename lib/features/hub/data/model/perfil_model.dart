class PerfilModel {
  final String nombreCompleto;
  final String correo;
  final String perfil;
  final String empresa;
  final String fechaIngreso;
  final int diasTotalesVacaciones;
  final int diasRestantesVacaciones;

  PerfilModel({
    required this.nombreCompleto,
    required this.correo,
    required this.perfil,
    required this.empresa,
    required this.fechaIngreso,
    required this.diasTotalesVacaciones,
    required this.diasRestantesVacaciones,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    final nombre = json['nombre'] ?? '';
    final paterno = json['apellidoPaterno'] ?? '';

    return PerfilModel(
      nombreCompleto: "$nombre $paterno".trim(),
      correo: json['correo'] ?? 'Sin correo',
      perfil: json['perfil'] ?? 'Sin perfil asignado',
      empresa: json['nombreEmpresa'] ?? 'N/A',
      fechaIngreso: json['fechaIngreso'] ?? 'No registrada',
      diasTotalesVacaciones: json['diasTotalesVacaciones'] ?? 0,
      diasRestantesVacaciones: json['diasRestantesVacaciones'] ?? 0,
    );
  }
}
