import 'package:finansale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:finansale/features/auth/presentation/cubit/auth_state.dart';
import 'package:finansale/features/rh/data/models/rh_dashboard_model.dart';
import 'package:finansale/features/rh/presentation/cubit/rh_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/rh_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Componentes compartidos
import '../../../../shared/widgets/anuncio_card.dart';
import '../../../../shared/widgets/naraes_header.dart';
import '../../../../shared/widgets/personalizado_card.dart';
import '../../../../shared/widgets/rh_widgets.dart';

class RhDashboardPage extends StatelessWidget {
  const RhDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el nombre del usuario desde el AuthCubit global
    final authState = context.watch<AuthCubit>().state;
    final nombreUsuario = (authState is AuthAuthenticated)
        ? authState.user.nombreCompleto
        : "Usuario";
    final rhCubit = context.read<RhCubit>();
    if (rhCubit.state is RhLoading) {
      final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;
      rhCubit.getDashboardData(user);
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go('/hub');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FCFF),
        body: BlocBuilder<RhCubit, RhState>(
          builder: (context, state) {
            // Estado de carga inicial
            if (state is RhLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF3E77BC)),
              );
            }

            // Manejo de errores traducidos
            if (state is RhError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }

            // Carga de datos exitosa
            if (state is RhLoaded) {
              final data = state.dashboardData;

              return RefreshIndicator(
                onRefresh: () async {
                  final user =
                      (context.read<AuthCubit>().state as AuthAuthenticated)
                          .user;
                  await context.read<RhCubit>().getDashboardData(user);
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Encabezado con información dinámica y progreso
                      _buildHeader(nombreUsuario, data.resumen),

                      Transform.translate(
                        offset: const Offset(0, -40),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Card de resumen con círculos estadísticos
                              _buildResumenPeriodo(data.resumen),

                              const SizedBox(height: 20),

                              // Renderizado condicional: Se oculta si el estado es nulo
                              if (data.ultimaSolicitud != null) ...[
                                const _SectionHeader(
                                  title: "Estado de la solicitud ",
                                ),
                                const SizedBox(height: 10),
                                PersonalizadoCard(
                                  child: StatusStepper(
                                    estados: data.ultimaSolicitud!.estados,
                                  ),
                                ),
                                const SizedBox(height: 25),
                              ],

                              // Sección de aprobaciones obtenidas del backend
                              const _SectionHeader(
                                title: "Aprobaciones Pendientes",
                              ),
                              const SizedBox(height: 10),
                              _buildListaAprobaciones(data.aprobaciones),

                              const SizedBox(height: 25),

                              // Card de anuncios estática
                              const _SectionHeader(title: "ANUNCIOS"),
                              const SizedBox(height: 10),
                              const AnuncioCard(
                                title: "¡Felicidades a los cumpleañeros!",
                                description:
                                    "Revisa quién cumple años este mes en tu equipo y envíales un saludo.",
                                imageUrl:
                                    "https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=1000&auto=format&fit=crop",
                                category: "CUMPLEAÑOS",
                                icon: Icons.cake_rounded,
                                iconColor: Colors.pinkAccent,
                              ),

                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // --- Widgets de apoyo ---

  Widget _buildHeader(String nombre, ResumenPeriodo resumen) {
    return NaraesHeader(
      title: nombre,
      bottomWidget: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Progreso de Días",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${(resumen.porcentajeProgreso * 100).toInt()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: resumen.porcentajeProgreso,
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildResumenPeriodo(ResumenPeriodo resumen) {
    return PersonalizadoCard(
      child: Column(
        children: [
          Text(
            "RESUMEN DEL PERIODO ${resumen.periodo}",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularStat(
                value: "${resumen.usados}",
                label: "GOCE",
                color: Colors.green,
              ),
              CircularStat(
                value: "${resumen.pendientes}",
                label: "PLAN",
                color: Colors.orange,
              ),
              CircularStat(
                value: "${resumen.totales}",
                label: "LEY",
                color: const Color(0xFF3E77BC),
              ),
            ],
          ),
        ],
      ),
    );
  }

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

    return Column(
      children: lista.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PersonalizadoCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF3E77BC),
                child: Icon(Icons.person, color: Colors.white),
              ),
              // PROPIEDADES CON PUNTO, NO CON CORCHETES
              title: Text(
                item.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Del ${item.fechaInicio} al ${item.fechaFin}"),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                // Aquí puedes usar item.id para navegar al detalle
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Ver todas",
          style: TextStyle(
            color: Color(0xFF3E77BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
