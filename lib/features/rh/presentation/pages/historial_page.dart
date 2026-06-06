import 'package:finansale/features/rh/presentation/cubit/detalle_solicitud_cubit.dart';
import 'package:finansale/features/rh/presentation/pages/detalle_solicitud_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Imports de Autenticación
import 'package:finansale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:finansale/features/auth/presentation/cubit/auth_state.dart';

// Imports de Recursos Humanos (Cubits y Estados)
import 'package:finansale/features/rh/presentation/cubit/solicitudes_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/solicitudes_state.dart';
import 'package:finansale/features/rh/presentation/cubit/aprobaciones_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/aprobaciones_state.dart';

// Imports de Datos y Modelos
import 'package:finansale/features/rh/data/models/solicitud_item_model.dart';
import 'package:finansale/features/rh/data/models/rh_dashboard_model.dart';

// Widgets fijos superiores
import 'package:finansale/features/rh/presentation/widgets/historial_widgets.dart';
import 'package:finansale/shared/widgets/personalizado_card.dart';

class HistorialSolicitudesPage extends StatefulWidget {
  const HistorialSolicitudesPage({super.key});

  @override
  State<HistorialSolicitudesPage> createState() =>
      _HistorialSolicitudesPageState();
}

class _HistorialSolicitudesPageState extends State<HistorialSolicitudesPage> {
  @override
  void initState() {
    super.initState();
    // 1. Aquí SOLO llamamos a SolicitudesCubit (porque ya existe arriba en el árbol global)
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<SolicitudesCubit>().getMisSolicitudes(authState.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final authenticatedUser = authState is AuthAuthenticated
        ? authState.user
        : null;

    return BlocProvider<AprobacionesCubit>(
      create: (context) {
        final cubit = AprobacionesCubit();
        if (authenticatedUser != null) {
          cubit.getListaAprobaciones(authenticatedUser);
        }
        return cubit;
      },

      child: Builder(
        builder: (newContext) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Theme.of(newContext).scaffoldBackgroundColor,
              appBar: AppBar(
                title: const Text(
                  "Mi Historial",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(newContext).colorScheme.onSurface,
              ),
              body: BlocBuilder<SolicitudesCubit, SolicitudesState>(
                builder: (context, state) {
                  if (state is SolicitudesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3E77BC),
                      ),
                    );
                  }

                  if (state is SolicitudesError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  if (state is SolicitudesLoaded) {
                    final solicitudes = state.solicitudes;
                    final resumen = state.resumen;

                    final int pendientes = resumen['dias_pendientes'] ?? 0;
                    final int totales = resumen['dias_totales'] ?? 0;
                    final int usados = resumen['dias_usados'] ?? 0;
                    final String periodo =
                        resumen['periodo'] ?? 'Periodo Actual';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- SECCIÓN FIJA SUPERIOR ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              ResumenCard(totales: pendientes),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: StatCard(
                                      titulo: "DÍAS TOTALES",
                                      valor: totales,
                                      icon: Icons.calendar_month_rounded,
                                      iconColor: const Color(0xFF3E77BC),
                                      bgColor: const Color(0xFFF1F5F9),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: StatCard(
                                      titulo: "DÍAS USADOS",
                                      valor: usados,
                                      icon: Icons.bar_chart_rounded,
                                      iconColor: const Color(0xFF10B981),
                                      bgColor: const Color(0xFFECFDF5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: Text(
                                  "Ciclo activo: $periodo",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- SECCIÓN DE TABS ---
                        Container(
                          width: double.infinity,
                          color: Theme.of(newContext).cardColor,
                          child: TabBar(
                            indicatorColor: const Color(0xFF3E77BC),
                            indicatorWeight: 3,
                            labelColor: const Color(0xFF3E77BC),
                            unselectedLabelColor: const Color(0xFF64748B),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            tabs: const [
                              Tab(text: "MIS SOLICITUDES"),
                              Tab(text: "APROBACIONES"),
                            ],
                          ),
                        ),

                        // --- CONTENIDO DE TABS ---
                        Expanded(
                          child: TabBarView(
                            children: [
                              // 1. PESTAÑA: MIS SOLICITUDES
                              solicitudes.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "No tienes solicitudes en este ciclo",
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      itemCount: solicitudes.length,
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                            height: 1,
                                            indent: 16,
                                            endIndent: 16,
                                          ),
                                      itemBuilder: (context, idx) {
                                        final item = solicitudes[idx];
                                        return ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 4,
                                              ),
                                          leading: _buildIconoTipo(
                                            item.tipoSolicitud,
                                          ),
                                          title: Text(
                                            "${item.tipoSolicitud} - #${item.id}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          subtitle: Text(
                                            item.estado.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  item.estado.toLowerCase() ==
                                                      'pendiente'
                                                  ? const Color(0xFF7C3AED)
                                                  : const Color(0xFF10B981),
                                            ),
                                          ),
                                          trailing: Text(
                                            "${item.fechaInicio} / ${item.fechaFin}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF64748B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          onTap: () {
                                            final authState = context
                                                .read<AuthCubit>()
                                                .state;
                                            final user =
                                                authState is AuthAuthenticated
                                                ? authState.user
                                                : null;

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MultiBlocProvider(
                                                  providers: [
                                                    // 🚀 Inyectamos el Cubit General para que el Listener de edición funcione
                                                    BlocProvider<
                                                      SolicitudesCubit
                                                    >(
                                                      create: (context) =>
                                                          SolicitudesCubit(),
                                                    ),
                                                    // 🚀 Inyectamos el Cubit Local que se encarga de cargar el Timeline nativo
                                                    BlocProvider<
                                                      DetalleSolicitudCubit
                                                    >(
                                                      create: (context) {
                                                        final cubit =
                                                            DetalleSolicitudCubit();
                                                        if (user != null) {
                                                          cubit.getDetalleSolicitud(
                                                            user,
                                                            item.id,
                                                          ); // Dispara la carga inicial
                                                        }
                                                        return cubit;
                                                      },
                                                    ),
                                                  ],
                                                  child: DetalleSolicitudPage(
                                                    idSolicitud: item.id,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),

                              // 2. PESTAÑA: BANDEJA DE APROBACIONES PENDIENTES
                              // 🚀 NOTA CRÍTICA: Usa 'newContext' para asegurar la lectura del Provider local
                              BlocBuilder<AprobacionesCubit, AprobacionesState>(
                                bloc: BlocProvider.of<AprobacionesCubit>(
                                  newContext,
                                ),
                                builder: (context, aprobacionesState) {
                                  if (aprobacionesState
                                      is AprobacionesLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF3E77BC),
                                      ),
                                    );
                                  }
                                  if (aprobacionesState is AprobacionesError) {
                                    return Center(
                                      child: Text(
                                        aprobacionesState.message,
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    );
                                  }
                                  if (aprobacionesState is AprobacionesLoaded) {
                                    return _buildListaAprobaciones(
                                      aprobacionesState.aprobaciones,
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // --- MANTENIDO: ICONOS DINÁMICOS POR TIPO ---
  Widget _buildIconoTipo(String tipoSolicitud) {
    final String tipo = tipoSolicitud.toLowerCase();
    IconData iconData = Icons.assignment_rounded;
    Color bgColor = const Color(0xFFF1F5F9);
    Color iconColor = const Color(0xFF64748B);

    if (tipo.contains('vacaciones')) {
      iconData = Icons.beach_access_rounded;
      bgColor = const Color(0xFFFEF3C7);
      iconColor = const Color(0xFFD97706);
    } else if (tipo.contains('permiso')) {
      iconData = Icons.article_rounded;
      bgColor = const Color(0xFFE0F2FE);
      iconColor = const Color(0xFF0369A1);
    } else if (tipo.contains('dentista')) {
      iconData = Icons.medical_services_rounded;
      bgColor = const Color(0xFFE0F2FE);
      iconColor = const Color(0xFF0F766E);
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: bgColor,
      child: Icon(iconData, color: iconColor, size: 18),
    );
  }

  // --- MANTENIDO: TU LISTA DE APROBACIONES EN LISTTILE PURO ---
  Widget _buildListaAprobaciones(List<AprobacionPendiente> lista) {
    if (lista.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "No hay solicitudes pendientes",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: lista.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final item = lista[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 4,
          ),
          leading: const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF3E77BC),
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          title: Text(
            item.nombre,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: const Text(
            "PENDIENTE DE AUTORIZAR",
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF7C3AED),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            "${item.fechaInicio} / ${item.fechaFin}",
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            final authState = context.read<AuthCubit>().state;
            final user = authState is AuthAuthenticated ? authState.user : null;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SolicitudesCubit>(
                      create: (context) => SolicitudesCubit(),
                    ),
                    BlocProvider<DetalleSolicitudCubit>(
                      create: (context) {
                        final cubit = DetalleSolicitudCubit();
                        if (user != null) {
                          cubit.getDetalleSolicitud(user, item.id);
                        }
                        return cubit;
                      },
                    ),
                  ],
                  child: DetalleSolicitudPage(idSolicitud: item.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
