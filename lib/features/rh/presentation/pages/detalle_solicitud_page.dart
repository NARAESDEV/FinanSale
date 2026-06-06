import 'package:finansale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:finansale/features/auth/presentation/cubit/auth_state.dart';
import 'package:finansale/features/rh/presentation/cubit/solicitudes_cubit.dart';
import 'package:finansale/features/rh/presentation/widgets/notas_chat_sheet.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/solicitudes_state.dart';
import '../../../../shared/widgets/personalizado_card.dart';
import '../../data/models/detalle_solicitud_model.dart';
import '../cubit/detalle_solicitud_cubit.dart';
import '../cubit/detalle_solicitud_state.dart';

class DetalleSolicitudPage extends StatefulWidget {
  final int idSolicitud;
  const DetalleSolicitudPage({super.key, required this.idSolicitud});

  @override
  State<DetalleSolicitudPage> createState() => _DetalleSolicitudPageState();
}

class _DetalleSolicitudPageState extends State<DetalleSolicitudPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<DetalleSolicitudCubit>().getDetalleSolicitud(
        authState.user,
        widget.idSolicitud,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Detalle de Solicitud",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          BlocBuilder<DetalleSolicitudCubit, DetalleSolicitudState>(
            builder: (context, state) {
              if (state is DetalleSolicitudLoaded) {
                final detalle = state.detalle;

                // Evaluamos si el paso actual en el Timeline es 'pendiente'
                final bool esEditable = detalle.historialCambios.any(
                  (c) => c.actual && c.estado.toLowerCase() == 'pendiente',
                );

                if (esEditable) {
                  return IconButton(
                    icon: const Icon(
                      Icons.edit_calendar_rounded,
                      color: Color(0xFF3E77BC),
                    ),
                    tooltip: "Modificar Fechas",
                    onPressed: () => _abrirSelectorFechas(context, detalle),
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      // Envolvemos todo el bloque del paso 1 con este Listener global
      body: BlocListener<SolicitudesCubit, SolicitudesState>(
        listener: (context, state) {
          if (state is SolicitudEditadaExito) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("✅ Solicitud modificada con éxito"),
                backgroundColor: Color(0xFF10B981),
              ),
            );

            final authState = context.read<AuthCubit>().state;
            if (authState is AuthAuthenticated) {
              context.read<DetalleSolicitudCubit>().getDetalleSolicitud(
                authState.user,
                widget.idSolicitud,
              );
            }
          }
        },
        // 🚀 CORRECCIÓN AQUÍ: Cambiar 'builder:' por 'child:' en el Listener
        child: BlocBuilder<DetalleSolicitudCubit, DetalleSolicitudState>(
          builder: (context, state) {
            if (state is DetalleSolicitudLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF3E77BC)),
              );
            }
            if (state is DetalleSolicitudError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }
            if (state is DetalleSolicitudLoaded) {
              final detalle = state.detalle;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(detalle),
                    const SizedBox(height: 32),
                    const Text(
                      "ESTADO DE LA SOLICITUD",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(detalle.historialCambios.length, (index) {
                      final cambio = detalle.historialCambios[index];
                      final bool isLast =
                          index == detalle.historialCambios.length - 1;
                      return _buildTimelineStep(
                        cambio,
                        isLast,
                        detalle.nombreResponsable,
                      );
                    }),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Invoca el bottom sheet agnóstico pasándole el ID de la solicitud actual
          NotasChatSheet.show(context, widget.idSolicitud);
        },
        elevation: 4,
        backgroundColor: const Color(
          0xFF3E77BC,
        ), // Tu azul corporativo principal
        icon: const Icon(
          Icons.chat_bubble_rounded,
          color: Colors.white,
          size: 20,
        ),
        label: const Text(
          " Notas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // Tarjeta superior adaptada a la referencia visual de la captura
  Widget _buildHeaderCard(DetalleSolicitudModel detalle) {
    final bool esPendiente = detalle.historialCambios.any(
      (c) => c.actual && c.estado.toLowerCase() == 'pendiente',
    );

    return PersonalizadoCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF3E77BC),
                  child: Text(
                    detalle.nombreSolicitante.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detalle.nombreSolicitante,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Colaborador",
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: esPendiente
                        ? const Color(0xFFF1E7FF)
                        : const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    esPendiente ? "PENDIENTE" : "PROCESADO",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: esPendiente
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Color(0xFF3E77BC),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Periodo Solicitado",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${detalle.fechaInicio} al ${detalle.fechaFin}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.beach_access_rounded,
                        color: Color(0xFFD97706),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tipo",
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            detalle.tipoSolicitud,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.date_range_rounded,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Días Totales",
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${detalle.diasTotalesVacaciones} Días",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(
    CambioHistorialModel cambio,
    bool isLast,
    String responsable,
  ) {
    // 1. Configuración de colores semánticos basados en el Texto del Estado
    final String estadoLower = cambio.estado.toLowerCase();

    Color statusColor = const Color(
      0xFF64748B,
    ); // Gris por defecto (Futuro o inactivo)
    Color statusBg = const Color(0xFFF8FAFC); // Fondo gris muy suave
    IconData stepIcon = Icons.radio_button_unchecked_rounded;

    if (cambio.pasado || cambio.actual) {
      if (estadoLower == 'pendiente' || estadoLower == 'reasignada') {
        statusColor = const Color(
          0xFF7C3AED,
        ); // Morado para transiciones/esperas
        statusBg = const Color(0xFFF5F3FF); // Morado pastel suave
        stepIcon = cambio.actual
            ? Icons.play_circle_filled_rounded
            : Icons.check_circle_rounded;
      } else if (estadoLower == 'aprobada' || estadoLower == 'finalizada') {
        statusColor = const Color(0xFF10B981); // Verde para éxito
        statusBg = const Color(0xFFECFDF5); // Verde pastel suave
        stepIcon = Icons.check_circle_rounded;
      } else if (estadoLower == 'rechazada' || estadoLower == 'cancelada') {
        statusColor = const Color(0xFFEF4444); // Rojo para alertas/negaciones
        statusBg = const Color(0xFFFEF2F2); // Rojo pastel suave
        stepIcon = Icons.cancel_rounded;
      }
    }

    // 2. Si es el estado ACTUAL, remarcamos el fondo con más fuerza y le damos un borde
    final bool resaltarCard = cambio.actual;

    return Stack(
      children: [
        // LÍNEA VERTICAL DE FONDO (Se ajusta al alto del contenedor de forma nativa)
        if (!isLast)
          Positioned(
            top:
                24, // Ajustado para que salga perfectamente del centro del avatar
            bottom: 0,
            left:
                24, // Alineado milimétricamente con el centro del CircleAvatar de la fila
            child: Container(
              width: 2,
              color: cambio.pasado
                  ? const Color(0xFF10B981)
                  : const Color(0xFFE2E8F0),
            ),
          ),

        // CONTENIDO DEL PASO DEL TIMELINE
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Círculo indicador con el icono de estado
              CircleAvatar(
                radius: 24,
                backgroundColor: resaltarCard ? statusColor : statusBg,
                child: Icon(
                  stepIcon,
                  color: resaltarCard ? Colors.white : statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),

              // Tarjeta contenedora de la información del estado
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // Pintamos el fondo suave dependiendo del estado
                    color: statusBg,
                    borderRadius: BorderRadius.circular(16),
                    // Si es el estado actual, le metemos un borde sólido del color del estatus
                    border: Border.all(
                      color: resaltarCard
                          ? statusColor
                          : statusColor.withOpacity(0.1),
                      width: resaltarCard ? 2 : 1,
                    ),
                    boxShadow: resaltarCard
                        ? [
                            BoxShadow(
                              color: statusColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cambio.estado.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: resaltarCard
                                  ? statusColor
                                  : const Color(0xFF1E293B),
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (cambio.actual)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "ACTUAL",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cambio.actual
                            ? "Tu solicitud está aquí. Actualmente bajo la revisión y supervisión técnica de: $responsable."
                            : (cambio.pasado
                                  ? "Etapa procesada y validada en el historial del flujo."
                                  : "Etapa subsecuente programada en el árbol de aprobaciones."),
                        style: TextStyle(
                          fontSize: 13,
                          color: resaltarCard
                              ? const Color(0xFF334155)
                              : const Color(0xFF64748B),
                          height: 1.4,
                          fontWeight: resaltarCard
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _abrirSelectorFechas(
    BuildContext context,
    DetalleSolicitudModel detalle,
  ) async {
    // 1. Parsear los strings del detalle a DateTime para el calendario
    final DateTime fechaInicioActual =
        DateTime.tryParse(detalle.fechaInicio) ?? DateTime.now();
    final DateTime fechaFinActual =
        DateTime.tryParse(detalle.fechaFin) ?? DateTime.now();

    // 2. Desplegar el componente nativo de rango de fechas
    final DateTimeRange? nuevoRango = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: fechaInicioActual,
        end: fechaFinActual,
      ),
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ), // Un año atrás máximo
      lastDate: DateTime(2030),
      confirmText: "MODIFICAR",
      saveText: "MODIFICAR",
      helpText: "SELECCIONA EL NUEVO PERIODO",
    );

    // 3. Si el usuario guardó los cambios, mandamos el payload a Flask
    if (nuevoRango != null) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        // Formateamos estrictamente a YYYY-MM-DD
        final String fInicioFormateada = nuevoRango.start
            .toIso8601String()
            .split('T')[0];
        final String fFinFormateada = nuevoRango.end.toIso8601String().split(
          'T',
        )[0];

        // Ejecutamos el método PUT de tu Cubit centralizado
        context.read<SolicitudesCubit>().editarSolicitud(
          user: authState.user,
          idSolicitudAEditar: detalle.idSolicitud,
          fechaInicio: fInicioFormateada,
          fechaFin: fFinFormateada,
        );
      }
    }
  }
}
