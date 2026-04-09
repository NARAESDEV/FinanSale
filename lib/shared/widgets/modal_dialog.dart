import 'package:flutter/material.dart';

enum DialogType { success, error, warning, info }

class ModalDialog extends StatelessWidget {
  final String title;
  final String message;
  final DialogType type;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ModalDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = DialogType.info,
    this.confirmText = "Aceptar",
    this.cancelText,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // Mapeo de colores e iconos según el tipo de alerta
    final config = _getDialogConfig();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta al contenido
          children: [
            // Icono con contenedor circular estilizado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: config.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(config.icon, color: config.color, size: 40),
            ),
            const SizedBox(height: 20),

            // Título
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            // Mensaje
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // Botones de acción
            Row(
              children: [
                if (cancelText != null)
                  Expanded(
                    child: TextButton(
                      onPressed: onCancel ?? () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        cancelText!,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (cancelText != null) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _DialogConfig _getDialogConfig() {
    switch (type) {
      case DialogType.success:
        return _DialogConfig(
          Icons.check_circle_outline_rounded,
          const Color(0xFF10B981),
        );
      case DialogType.error:
        return _DialogConfig(
          Icons.error_outline_rounded,
          const Color(0xFFEF4444),
        );
      case DialogType.warning:
        return _DialogConfig(
          Icons.warning_amber_rounded,
          const Color(0xFFF59E0B),
        );
      case DialogType.info:
      default:
        return _DialogConfig(
          Icons.info_outline_rounded,
          const Color(0xFF3E77BC),
        );
    }
  }
}

class _DialogConfig {
  final IconData icon;
  final Color color;
  _DialogConfig(this.icon, this.color);
}
