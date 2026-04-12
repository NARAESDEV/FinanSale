import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importa los widgets aislados (FSD)
import 'widgets/perfil_widgets.dart';

// Importa el cubit y el estado
import 'cubit/perfil_cubit.dart';
import 'cubit/perfil_state.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // mostrar confirmación
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FCFF),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<PerfilCubit, PerfilState>(
            builder: (context, state) {
              if (state is PerfilLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF3E77BC)),
                );
              }

              if (state is PerfilError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state is PerfilLoaded) {
                final perfil = state.perfil;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: Text(
                          "Mi Perfil",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ),

                    // SECCIÓN CABECERA (Avatar)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PerfilHeader(perfil: perfil),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),

                    // SECCIÓN LABORAL
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: InfoLaboralCard(perfil: perfil),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // SECCIÓN VACACIONES
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: VacacionesCard(perfil: perfil),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // SECCIÓN CONFIGURACIÓN
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 100,
                        ), // Padding para el Navbar
                        child: ConfiguracionCard(),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
