import 'package:finansale/features/rh/data/models/subtipo_solicitud_model.dart';
import 'package:finansale/features/rh/presentation/cubit/subtipos/subtipos_cubit.dart';
import 'package:finansale/features/rh/presentation/widgets/selector_subtipos_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Importante para el formato YYYY-MM-DD
import '../widgets/info_card_solicitud.dart';
import '../widgets/seccion_adjuntos.dart';

class NuevaSolicitudPage extends StatefulWidget {
  const NuevaSolicitudPage({super.key});

  @override
  State<NuevaSolicitudPage> createState() => _NuevaSolicitudPageState();
}

class _NuevaSolicitudPageState extends State<NuevaSolicitudPage> {
  SubtipoSolicitudModel? _subtipoSeleccionado;

  // Variables de Estado para el Calendario
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  // ----------------------------------------------------------------
  // LÓGICA DE NEGOCIO: CÁLCULO DE DÍAS HÁBILES (Sin fines de semana)
  // ----------------------------------------------------------------
  DateTime _calcularDiasHabiles(DateTime inicio, int diasASumar) {
    DateTime fechaResultante = inicio;
    int diasAgregados = 0;
    // Empezamos asumiendo que el primer día seleccionado ya cuenta como 1, por lo que sumamos diasASumar - 1
    int diasRestantes = diasASumar > 0 ? diasASumar - 1 : 0;

    while (diasAgregados < diasRestantes) {
      fechaResultante = fechaResultante.add(const Duration(days: 1));
      // Si NO es sábado ni domingo, contamos el día
      if (fechaResultante.weekday != DateTime.saturday &&
          fechaResultante.weekday != DateTime.sunday) {
        diasAgregados++;
      }
    }
    return fechaResultante;
  }

  // ----------------------------------------------------------------
  // GESTIÓN DEL CALENDARIO SEGÚN EL TRÁMITE
  // ----------------------------------------------------------------
  Future<void> _seleccionarFechas() async {
    if (_subtipoSeleccionado == null) return;

    final int idTramite = _subtipoSeleccionado!.idSubtipoSolicitud;

    // 1. REGLA: CUMPLEAÑOS (ID 3) -> Solo 1 día exacto
    if (idTramite == 3) {
      final selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        helpText: "Selecciona el día de Cumpleaños",
      );
      if (selected != null) {
        setState(() {
          _fechaInicio = selected;
          _fechaFin = selected;
        });
      }
      return;
    }

    // 2. REGLA: PATERNIDAD/MATERNIDAD (ID 1) -> 5 días por defecto saltando fines de semana
    if (idTramite == 1) {
      final selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        helpText: "Selecciona el inicio de Paternidad/Maternidad",
      );
      if (selected != null) {
        setState(() {
          _fechaInicio = selected;
          // NOTA: Como Paternidad y Maternidad comparten ID 1, aplicamos 5 días (Paternidad).
          // Si necesitas 84 días para Maternidad, tendremos que agregar un Switch o Dialog extra aquí.
          _fechaFin = _calcularDiasHabiles(selected, 5);
        });
      }
      return;
    }

    // 3. REGLA: ENFERMEDAD (ID 2) O VACACIONES -> Rango de fechas libre
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(
        const Duration(days: 30),
      ), // Permite retroactivo
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: "Selecciona el periodo",
    );
    if (pickedRange != null) {
      setState(() {
        _fechaInicio = pickedRange.start;
        _fechaFin = pickedRange.end;
      });
    }
  }

  // ----------------------------------------------------------------
  // JSON BUILDER: PREPARACIÓN DEL PAYLOAD
  // ----------------------------------------------------------------
  void _prepararPayload() {
    if (_fechaInicio == null ||
        _fechaFin == null ||
        _subtipoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, completa todos los campos del trámite."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final format = DateFormat('yyyy-MM-dd');
    final payload = {
      "fechaInicio": format.format(_fechaInicio!),
      "fechaFin": format.format(_fechaFin!),
      "idTipoSolicitud": _subtipoSeleccionado!.idTipoSolicitud,
    };

    // Esto te imprimirá el JSON exacto en la consola para confirmar que funciona
    print("🚀 PAYLOAD LISTO PARA ENVIAR: $payload");

    // El siguiente paso será enviar este payload a un nuevo Cubit (Ej. CrearSolicitudCubit)
  }

  void _abrirSelector() async {
    final subtiposCubit = context.read<SubtiposCubit>();
    final resultado = await showModalBottomSheet<SubtipoSolicitudModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: subtiposCubit,
        child: const SelectorSubtiposBottomSheet(),
      ),
    );

    if (resultado != null) {
      setState(() {
        _subtipoSeleccionado = resultado;
        // Limpiamos fechas si cambian de trámite
        _fechaInicio = null;
        _fechaFin = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Variable de control para ocultar sección de adjuntos
    final bool esCumpleanos = _subtipoSeleccionado?.idSubtipoSolicitud == 3;
    final formatStr = DateFormat('dd MMM yyyy');

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

              if (_subtipoSeleccionado != null)
                InfoCardSolicitud(
                  label: "Trámite de ${_subtipoSeleccionado!.subtipoSolicitu}",
                  // Calcula los días seleccionados dinámicamente para mostrarlos en la UI
                  value: _fechaInicio != null && _fechaFin != null
                      ? (_fechaFin!.difference(_fechaInicio!).inDays + 1)
                            .toString()
                      : "-",
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

              // BOTÓN DEL CALENDARIO INTERACTIVO
              InkWell(
                onTap: _subtipoSeleccionado == null ? null : _seleccionarFechas,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFF1F5F9),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF3E77BC),
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _fechaInicio == null
                            ? "Toca para abrir calendario"
                            : "${formatStr.format(_fechaInicio!)}  al  ${formatStr.format(_fechaFin!)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: _fechaInicio == null
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF1E293B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // RENDERIZADO CONDICIONAL DE LOS ADJUNTOS
              if (!esCumpleanos && _subtipoSeleccionado != null) ...[
                const SeccionAdjuntos(),
                const SizedBox(height: 40),
              ],

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
        onPressed: _prepararPayload,
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
