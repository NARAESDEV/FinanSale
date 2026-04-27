class SubtipoSolicitudModel {
  final int idSubtipoSolicitud;
  final int idTipoSolicitud;
  final String subtipoSolicitu; // Nombre del trámite (Paternidad, etc.)
  final bool estado;

  SubtipoSolicitudModel({
    required this.idSubtipoSolicitud,
    required this.idTipoSolicitud,
    required this.subtipoSolicitu,
    required this.estado,
  });

  factory SubtipoSolicitudModel.fromJson(Map<String, dynamic> json) {
    return SubtipoSolicitudModel(
      idSubtipoSolicitud: json['idSubtipoSolicitud'],
      idTipoSolicitud: json['idTipoSolicitud'],
      subtipoSolicitu: json['subtipoSolicitu'],
      estado: json['estado'],
    );
  }
}
