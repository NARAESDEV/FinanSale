import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/personalizado_card.dart';
import '../cubit/solicitudes_cubit.dart';
import '../cubit/solicitudes_state.dart';

class EstadoSolicitudesPage extends StatelessWidget {
  const EstadoSolicitudesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E77BC),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Mis Solicitudes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<SolicitudesCubit, SolicitudesState>(
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
            final lista = state.solicitudes;

            if (lista.isEmpty) {
              return const Center(
                child: Text(
                  "No has realizado solicitudes",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final item = lista[index];

                // Obtenemos los colores dinámicos basados en el estado
                final Map<String, Color> coloresBadge = _getColorPorEstado(
                  item.estado,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: PersonalizadoCard(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        print("Tocado el id: ${item.id}");
                        // context.push('/detalle-solicitud/${item.id}');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: const Color(0xFFF7E7A8),
                                child: Text(
                                  obtenerIniciales(item.nombre),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFBE8B17),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.nombre,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Solicitud de vacaciones',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: coloresBadge['bg'],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  item.estado,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: coloresBadge['text'],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F7FA),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 18,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Del ${item.fechaInicio} al ${item.fechaFin}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 24,
                                  color: Color(0xFFC0C8D4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  // --- Helpers ---
  String obtenerIniciales(String nombre) {
    final partes = nombre
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
  }

  Map<String, Color> _getColorPorEstado(String estado) {
    final estadoLower = estado.toLowerCase();
    if (estadoLower.contains('aprobada')) {
      return {
        'bg': const Color(0xFFE6F4EA),
        'text': const Color(0xFF137333),
      }; // Verde
    } else if (estadoLower.contains('rechazada')) {
      return {
        'bg': const Color(0xFFFCE8E6),
        'text': const Color(0xFFC5221F),
      }; // Rojo
    }
    // Por defecto (Pendiente) el color morado de tu diseño
    return {'bg': const Color(0xFFF1E7FF), 'text': const Color(0xFF7C3AED)};
  }
}
