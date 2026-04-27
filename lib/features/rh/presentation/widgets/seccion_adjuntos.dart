import 'package:flutter/material.dart';

class SeccionAdjuntos extends StatelessWidget {
  const SeccionAdjuntos({super.key});

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
              onTap: () => print("Abrir Cámara"),
            ),
            const SizedBox(width: 12),
            _adjuntoBtn(
              icon: Icons.file_present_rounded,
              label: "Adjuntar Archivo",
              onTap: () => print("Abrir Selector de Archivos"),
            ),
          ],
        ),
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
