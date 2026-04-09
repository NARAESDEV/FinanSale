class UserModel {
  final String correo;
  final String idEmpresa;
  final String idPerfil;
  final String idUsuario;
  final String nombreCompleto;
  final String perfil;
  final List<PermissionModel> permisos;
  String? contrasena;

  UserModel({
    required this.correo,
    required this.idEmpresa,
    required this.idPerfil,
    required this.idUsuario,
    required this.nombreCompleto,
    required this.perfil,
    required this.permisos,
    this.contrasena,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      correo: json['correo'] ?? '',
      idEmpresa: json['idEmpresa'] ?? '',
      idPerfil: json['idPerfil'] ?? '',
      idUsuario: json['idUsuario'] ?? '',
      nombreCompleto: json['nombre_completo'] ?? '',
      perfil: json['perfil'] ?? '',
      permisos: (json['permisos'] as List)
          .map((p) => PermissionModel.fromJson(p))
          .toList(),
    );
  }
}

class PermissionModel {
  final String modulo;
  final bool lectura;
  final bool crear;
  final bool actualizar;
  final bool eliminar;

  PermissionModel({
    required this.modulo,
    required this.lectura,
    required this.crear,
    required this.actualizar,
    required this.eliminar,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      modulo: json['modulo'] ?? '',
      lectura: json['Lectura'] ?? false,
      crear: json['Crear'] ?? false,
      actualizar: json['Actualizar'] ?? false,
      eliminar: json['Eliminar'] ?? false,
    );
  }
}
