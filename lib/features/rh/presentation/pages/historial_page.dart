import 'package:finansale/features/rh/presentation/cubit/solicitudes_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/solicitudes_state.dart';
import 'package:finansale/features/rh/presentation/widgets/historial_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SolicitudesCubit, SolicitudesState>(
          builder: (context, state) {
            if (state is SolicitudesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF3E77BC)),
              );
            }

            if (state is SolicitudesError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is SolicitudesLoaded) {
              // Validamos que el mapa de resumen exista y extraemos valores de forma segura
              final resumen = state.resumen;
              final lista = state.solicitudes;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // TÍTULO DE LA PÁGINA
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Text(
                        "Historial de Solicitudes",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ),

                  // SECCIÓN DE TARJETAS DE RESUMEN
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ResumenCard(totales: resumen['dias_totales'] ?? 0),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  titulo: "UTILIZADOS",
                                  valor: resumen['dias_usados'] ?? 0,
                                  icon: Icons.calendar_today_rounded,
                                  iconColor: const Color(0xFF10B981),
                                  bgColor: const Color(0xFFECFDF5),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatCard(
                                  titulo: "PENDIENTES",
                                  valor: resumen['dias_pendientes'] ?? 0,
                                  icon: Icons.access_time_rounded,
                                  iconColor: const Color(0xFF3E77BC),
                                  bgColor: const Color(0xFFEFF6FF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // ENCABEZADO DE LA LISTA
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Historial por Ciclo",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: const Text(
                              "FILTRAR",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3E77BC),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // RENDERIZADO DE LA LISTA VÍA SLIVERS
                  if (lista.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            "No hay historial disponible",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                            left: 20,
                            right: 20,
                          ),
                          child: HistorialItemCard(item: lista[index]),
                        ),
                        childCount: lista.length,
                      ),
                    ),

                  // TARJETA DE INFORMACIÓN INFERIOR
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 12,
                        bottom: 100,
                      ),
                      child: InfoCard(),
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
  }
}
