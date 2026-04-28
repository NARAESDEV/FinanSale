class TipoSolicitudModel {
  final int idTipoSolicitud;
  final String tipoSolicitud;
  final bool estado;

  TipoSolicitudModel({
    required this.idTipoSolicitud,
    required this.tipoSolicitud,
    required this.estado,
  });

  factory TipoSolicitudModel.fromJson(Map<String, dynamic> json) {
    return TipoSolicitudModel(
      idTipoSolicitud: json['idTipoSolicitud'],
      tipoSolicitud: json['tipoSolicitud'],
      estado: json['estado'] ?? true,
    );
  }
}
