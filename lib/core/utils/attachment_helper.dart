import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AttachmentResult {
  final String nombre;
  final String tamanio;
  final String base64;

  AttachmentResult({
    required this.nombre,
    required this.tamanio,
    required this.base64,
  });
}

class AttachmentHelper {
  // 🔒 VALIDAR Y SOLICITAR PERMISOS (Versión Universal)
  static Future<bool> _solicitarPermisos() async {
    if (Platform.isAndroid) {
      // 'Permission.photos' es el equivalente universal para galerías en iOS y Android
      if (await Permission.photos.isGranted) return true;
      if (await Permission.storage.isGranted) return true;

      final Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
        Permission.storage,
      ].request();

      return statuses[Permission.photos]?.isGranted == true ||
          statuses[Permission.storage]?.isGranted == true;
    } else {
      final status = await Permission.photos.request();
      return status.isGranted || status.isLimited;
    }
  }

  // 📂 SELECCIONAR ARCHIVO Y TRANSFORMAR A BASE64
  static Future<AttachmentResult?> seleccionarAdjunto() async {
    final bool permisoConcedido = await _solicitarPermisos();
    if (!permisoConcedido) return null;

    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result == null || result.files.isEmpty) return null;

    final PlatformFile file = result.files.first;

    List<int>? fileBytes = file.bytes;
    if (fileBytes == null && file.path != null) {
      fileBytes = await File(file.path!).readAsBytes();
    }

    if (fileBytes == null) return null;

    final String nombreArchivo = file.name;
    final String tamanioKB = (file.size / 1024).round().toString();
    final String base64String = base64Encode(fileBytes);

    return AttachmentResult(
      nombre: nombreArchivo,
      tamanio: tamanioKB,
      base64: base64String,
    );
  }
}
