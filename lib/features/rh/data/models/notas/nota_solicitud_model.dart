class NotaSolicitudModel {
  final int idNota;
  final int idSolicitud;
  final String contenido;
  final String usuarioCreador;
  final String idUsuarioCr;
  final String fecCre;
  final String? nombreAdjunto;
  final String? rutaAdjunto;
  final String? adjuntoSize;
  final String? adjuntoBase64;

  NotaSolicitudModel({
    required this.idNota,
    required this.idSolicitud,
    required this.contenido,
    required this.usuarioCreador,
    required this.idUsuarioCr,
    required this.fecCre,
    this.nombreAdjunto,
    this.rutaAdjunto,
    this.adjuntoSize,
    this.adjuntoBase64,
  });

  factory NotaSolicitudModel.fromJson(Map<String, dynamic> json) {
    return NotaSolicitudModel(
      idNota: json['idNota'] ?? 0,
      idSolicitud: json['idSolicitud'] ?? 0,
      contenido: json['contenido'] ?? '',
      usuarioCreador: json['usuarioCreador'] ?? 'Sistema',
      idUsuarioCr: json['idUsuarioCr'] ?? '',
      fecCre: json['fecCre'] ?? '',
      nombreAdjunto: json['nombreAdjunto'],
      rutaAdjunto: json['rutaAdjunto'],
      adjuntoSize: json['adjuntoSize']?.toString(),
      adjuntoBase64: json['adjuntoBase64'],
    );
  }
}
