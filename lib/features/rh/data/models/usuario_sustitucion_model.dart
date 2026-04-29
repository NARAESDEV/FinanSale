class UsuarioSustitucionModel {
  final String idUsuario;
  final String nombreCompleto;

  UsuarioSustitucionModel({
    required this.idUsuario,
    required this.nombreCompleto,
  });

  factory UsuarioSustitucionModel.fromJson(Map<String, dynamic> json) {
    return UsuarioSustitucionModel(
      idUsuario: json['idUsuario'],
      nombreCompleto: json['nombre_completo'],
    );
  }
}
