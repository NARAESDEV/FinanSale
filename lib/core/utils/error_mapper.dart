class ErrorMapper {
  static String translate(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    // Errores de Conexión (Dio)
    if (errorStr.contains('connection timeout') ||
        errorStr.contains('socketexception')) {
      return "No pudimos conectar con el servidor. Revisa tu internet.";
    }

    // Errores de Mapeo
    if (errorStr.contains('is not a subtype of type')) {
      return "Error de formato en los datos Correo y Contraseña.";
    }

    // Errores comunes del Backend
    if (errorStr.contains('401') || errorStr.contains('invalid credentials')) {
      return "Correo o contraseña incorrectos. Verifica tus datos.";
    }

    if (errorStr.contains('404')) {
      return "El servicio no está disponible o el recurso solicitado no existe (404).";
    }

    // Error por defecto
    return "Ups: $errorStr";
  }
}
