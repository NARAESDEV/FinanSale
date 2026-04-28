import 'dart:io';

import 'package:image_picker/image_picker.dart';
// 1. LE PONEMOS EL ALIAS 'fp' A LA IMPORTACIÓN
import 'package:file_picker/file_picker.dart' as fp;
import 'package:permission_handler/permission_handler.dart';

class MediaService {
  static final ImagePicker _picker = ImagePicker();

  //TOMAR FOTO CON LA CÁMARA
  static Future<File?> tomarFoto() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      return photo != null ? File(photo.path) : null;
    }
    return null;
  }

  static Future<File?> seleccionarArchivo() async {
    fp.FilePickerResult? result = await fp.FilePicker.pickFiles(
      type: fp.FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}
