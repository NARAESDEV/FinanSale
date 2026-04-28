import 'dart:io';
import 'package:flutter/material.dart';

class SeccionAdjuntos extends StatelessWidget {
  final VoidCallback onTomarFoto;
  final VoidCallback onAdjuntarArchivo;
  final File? archivoActual;

  const SeccionAdjuntos({
    super.key,
    required this.onTomarFoto,
    required this.onAdjuntarArchivo,
    this.archivoActual,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ADJUNTAR COMPROBANTE",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _adjuntoBtn(
              icon: Icons.camera_alt_rounded,
              label: "Tomar Foto",
              onTap: onTomarFoto,
            ),
            const SizedBox(width: 12),
            _adjuntoBtn(
              icon: Icons.file_present_rounded,
              label: "Adjuntar Archivo",
              onTap: onAdjuntarArchivo,
            ),
          ],
        ),
        // Si hay un archivo seleccionado, mostramos una pequeña alerta de éxito
        if (archivoActual != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4), // Fondo verde claro
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF22C55E),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Archivo cargado: ${archivoActual!.path.split('/').last}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF166534),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _adjuntoBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF3E77BC), size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
