import '../data/models/user_model.dart';

extension UserPermissionsExt on UserModel {
  // Función para checar si tiene permiso de lectura en un módulo
  bool hasReadAccess(String moduloNombre) {
    return permisos.any((p) => p.modulo == moduloNombre && p.lectura);
  }

  // Función para checar si puede realizar acciones de escritura (Crear/Actualizar/Eliminar)
  bool hasWriteAccess(String moduloNombre) {
    final permiso = permisos.firstWhere(
      (p) => p.modulo == moduloNombre,
      orElse: () => PermissionModel(
        modulo: '',
        lectura: false,
        crear: false,
        actualizar: false,
        eliminar: false,
      ), // Si no existe, denegado
    );
    // Aquí puedes personalizar tu lógica: ¿es "escritura" si puede Crear O Actualizar?
    return permiso.lectura && (permiso.modulo != '');
    // Nota: Deberías mapear "Crear", "Actualizar", "Eliminar" en tu UserModel si los ocupas.
  }
}

// final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

// ElevatedButton(
//   // Si no tiene permiso, onPressed es null (botón deshabilitado automáticamente)
//   onPressed: user.hasWriteAccess('Recursos Humanos') 
//     ? () => ejecutarPost() 
//     : null, 
//   child: const Text("Guardar Cambios"),
// )