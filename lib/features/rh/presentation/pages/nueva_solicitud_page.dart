import 'package:finansale/features/rh/data/models/subtipo_solicitud_model.dart';
import 'package:finansale/features/rh/presentation/cubit/subtipos/subtipos_cubit.dart';
import 'package:finansale/features/rh/presentation/widgets/selector_subtipos_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/info_card_solicitud.dart';
import '../widgets/seccion_adjuntos.dart';

class NuevaSolicitudPage extends StatefulWidget {
  const NuevaSolicitudPage({super.key});

  @override
  State<NuevaSolicitudPage> createState() => _NuevaSolicitudPageState();
}

class _NuevaSolicitudPageState extends State<NuevaSolicitudPage> {
  SubtipoSolicitudModel? _subtipoSeleccionado;

  // Método para abrir el BottomSheet
  void _abrirSelector() async {
    final subtiposCubit = context.read<SubtiposCubit>();
    // Esperamos el resultado (el modelo seleccionado) que devuelve el Navigator.pop
    final resultado = await showModalBottomSheet<SubtipoSolicitudModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // 2. CREAMOS EL PUENTE: Usamos BlocProvider.value para inyectar el Cubit existente
      builder: (bottomSheetContext) => BlocProvider.value(
        value: subtiposCubit,
        child: const SelectorSubtiposBottomSheet(),
      ),
    );

    if (resultado != null) {
      setState(() {
        _subtipoSeleccionado = resultado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nueva Solicitud",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Completa los campos para procesar tu trámite.",
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),

              _label("¿QUÉ NECESITAS TRAMITAR?"),
              InkWell(
                onTap: _abrirSelector,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.edit_document, color: Color(0xFF3E77BC)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          // Muestra el seleccionado o el texto por defecto
                          _subtipoSeleccionado?.subtipoSolicitu ??
                              "Seleccionar trámite...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _subtipoSeleccionado != null
                                ? const Color(0xFF1E293B)
                                : const Color(0xFF94A3B8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Este es el widget dinámico que cambiará con el Cubit
              if (_subtipoSeleccionado != null)
                InfoCardSolicitud(
                  label: "Dias de ${_subtipoSeleccionado!.subtipoSolicitu}",
                  value: _subtipoSeleccionado!.idSubtipoSolicitud == 1
                      ? "5"
                      : "10", // Lógica simulada temporal
                  unit: "Días",
                  icon: Icons.assignment_rounded,
                ),

              if (_subtipoSeleccionado == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Selecciona un trámite para ver los detalles.",
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              _label("SOLICITANTE"),
              _textFieldReadOnly("Josue Israel"),

              const SizedBox(height: 24),

              _label("SELECCIONA EL PERIODO:"),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: const Center(child: Text("Calendario Placeholder")),
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: const Center(child: Text("Calendario Placeholder")),
              ),

              const SizedBox(height: 32),

              const SeccionAdjuntos(),

              const SizedBox(height: 40),

              _botonEnviar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _dropdownMock(String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3E77BC)),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF64748B),
          ),
        ],
      ),
    );
  }

  Widget _textFieldReadOnly(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF475569),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _botonEnviar() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3E77BC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Enviar Solicitud",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
