import 'package:finansale/features/rh/data/models/subtipo_solicitud_model.dart';
import 'package:finansale/features/rh/data/models/tipo_solicitud_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/solicitudes_cubit.dart';
import '../cubit/solicitudes_state.dart';
import '../cubit/subtipos/subtipos_cubit.dart';
import '../cubit/tipos/tipos_cubit.dart';
import '../widgets/info_card_solicitud.dart';
import '../widgets/selector_subtipos_bottom_sheet.dart';

class NuevaSolicitudPage extends StatefulWidget {
  const NuevaSolicitudPage({super.key});

  @override
  State<NuevaSolicitudPage> createState() => _NuevaSolicitudPageState();
}

class _NuevaSolicitudPageState extends State<NuevaSolicitudPage> {
  // --- VARIABLES DE ESTADO ---
  TipoSolicitudModel? _tipoSeleccionado;
  SubtipoSolicitudModel? _subtipoSeleccionado;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  // ¡AQUÍ ESTÁ LA VARIABLE FALTANTE!
  bool _isProcessing = false;

  // --- LÓGICA DE FECHAS ---
  DateTime _calcularDiasHabiles(DateTime inicio, int diasASumar) {
    DateTime fechaResultante = inicio;
    int diasAgregados = 0;
    int diasRestantes = diasASumar > 0 ? diasASumar - 1 : 0;

    while (diasAgregados < diasRestantes) {
      fechaResultante = fechaResultante.add(const Duration(days: 1));
      if (fechaResultante.weekday != DateTime.saturday &&
          fechaResultante.weekday != DateTime.sunday) {
        diasAgregados++;
      }
    }
    return fechaResultante;
  }

  Future<void> _seleccionarFechas() async {
    if (_tipoSeleccionado == null) return;

    final bool esCumpleanos =
        _subtipoSeleccionado?.subtipoSolicitu.toLowerCase().contains(
          "cumpleaños",
        ) ??
        false;
    final bool esPaternidad =
        _subtipoSeleccionado?.subtipoSolicitu.toLowerCase().contains(
          "paternidad",
        ) ??
        false;

    if (esCumpleanos) {
      final selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (selected != null) {
        setState(() {
          _fechaInicio = selected;
          _fechaFin = selected;
        });
      }
      return;
    }

    if (esPaternidad) {
      final selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (selected != null) {
        setState(() {
          _fechaInicio = selected;
          _fechaFin = _calcularDiasHabiles(selected, 5);
        });
      }
      return;
    }

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedRange != null) {
      setState(() {
        _fechaInicio = pickedRange.start;
        _fechaFin = pickedRange.end;
      });
    }
  }

  // --- DISPARADOR DEL POST (GUARDAR) ---
  void _prepararPayload() {
    if (_fechaInicio == null ||
        _fechaFin == null ||
        _tipoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa todos los campos obligatorios"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final format = DateFormat('yyyy-MM-dd');
    final authState = context.read<AuthCubit>().state;

    if (authState is AuthAuthenticated) {
      context.read<SolicitudesCubit>().crearSolicitud(
        user: authState.user,
        fechaInicio: format.format(_fechaInicio!),
        fechaFin: format.format(_fechaFin!),
        idTipoSolicitud: _tipoSeleccionado!.idTipoSolicitud,
      );
    }
  }

  // --- SELECTORES (BOTTOM SHEETS) ---
  void _abrirSelectorTipos() async {
    final tiposCubit = context.read<TiposCubit>();

    final resultado = await showModalBottomSheet<TipoSolicitudModel>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return BlocBuilder<TiposCubit, TiposState>(
          bloc: tiposCubit,
          builder: (context, state) {
            if (state is TiposLoading) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF3E77BC)),
                ),
              );
            }
            if (state is TiposError) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            if (state is TiposLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.tipos.length,
                itemBuilder: (context, index) {
                  final tipo = state.tipos[index];
                  return ListTile(
                    leading: const Icon(Icons.folder, color: Color(0xFF3E77BC)),
                    title: Text(
                      tipo.tipoSolicitud,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () => Navigator.pop(context, tipo),
                  );
                },
              );
            }
            return const SizedBox();
          },
        );
      },
    );

    if (resultado != null) {
      setState(() {
        _tipoSeleccionado = resultado;
        _subtipoSeleccionado = null;
        _fechaInicio = null;
        _fechaFin = null;
      });

      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        context.read<SubtiposCubit>().fetchSubtipos(
          authState.user,
          resultado.idTipoSolicitud,
        );
      }
    }
  }

  void _abrirSelectorSubtipos() async {
    if (_tipoSeleccionado == null) return;

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
      });
    }
  }

  // --- MODAL DE ÉXITO DINÁMICA ---
  void _mostrarModalExito() {
    final nombreTramite = _tipoSeleccionado?.tipoSolicitud ?? "trámite";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF22C55E),
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  "¡Éxito!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Registro de $nombreTramite exitoso.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E77BC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // 1. Cerramos el diálogo primero
                      Navigator.of(dialogContext).pop();

                      // 2. Redirigimos al Dashboard usando la ruta de GoRouter
                      // Esto limpia el stack y evita la pantalla negra.
                      // context.go('/rh-dashboard');
                    },
                    child: const Text(
                      "Aceptar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- UI PRINCIPAL ---
  @override
  Widget build(BuildContext context) {
    final formatStr = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      // BLOC LISTENER PARA ESCUCHAR AL BACKEND
      body: BlocListener<SolicitudesCubit, SolicitudesState>(
        listener: (context, state) {
          if (state is SolicitudesLoading) {
            setState(() => _isProcessing = true);
          } else {
            setState(() => _isProcessing = false);
          }

          if (state is SolicitudCreadaExito) {
            _mostrarModalExito();
          } else if (state is SolicitudesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Stack(
          children: [
            SafeArea(
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
                    const SizedBox(height: 32),

                    _label("TIPO DE TRÁMITE"),
                    InkWell(
                      onTap: _abrirSelectorTipos,
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
                            const Icon(
                              Icons.folder_open_rounded,
                              color: Color(0xFF3E77BC),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _tipoSeleccionado?.tipoSolicitud ??
                                    "Seleccionar tipo...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _tipoSeleccionado != null
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFF94A3B8),
                                ),
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

                    _label("SUBTIPO DE TRÁMITE"),
                    InkWell(
                      onTap: _tipoSeleccionado == null
                          ? null
                          : _abrirSelectorSubtipos,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _tipoSeleccionado == null
                              ? const Color(0xFFF1F5F9)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_document,
                              color: _tipoSeleccionado == null
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF3E77BC),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _subtipoSeleccionado?.subtipoSolicitu ??
                                    "Seleccionar especificacion...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _subtipoSeleccionado != null
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFF94A3B8),
                                ),
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
                        label:
                            "Especificación: ${_subtipoSeleccionado!.subtipoSolicitu}",
                        value: _fechaInicio != null && _fechaFin != null
                            ? (_fechaFin!.difference(_fechaInicio!).inDays + 1)
                                  .toString()
                            : "-",
                        unit: "Días",
                        icon: Icons.assignment_rounded,
                      ),

                    const SizedBox(height: 24),

                    _label("SELECCIONA EL PERIODO:"),
                    InkWell(
                      onTap: _tipoSeleccionado == null
                          ? null
                          : _seleccionarFechas,
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

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _prepararPayload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E77BC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                    ),
                  ],
                ),
              ),
            ),

            // --- PANTALLA DE CARGA (OVERLAY) ---
            if (_isProcessing)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        "Guardando...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
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
