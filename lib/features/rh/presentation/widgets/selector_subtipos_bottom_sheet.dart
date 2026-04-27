import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/subtipos/subtipos_cubit.dart';
import '../cubit/subtipos/subtipos_state.dart';

class SelectorSubtiposBottomSheet extends StatefulWidget {
  const SelectorSubtiposBottomSheet({super.key});

  @override
  State<SelectorSubtiposBottomSheet> createState() =>
      _SelectorSubtiposBottomSheetState();
}

class _SelectorSubtiposBottomSheetState
    extends State<SelectorSubtiposBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Altura máxima del 80% de la pantalla
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // --- HANDLE SUPERIOR (La rayita gris) ---
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Selecciona un Trámite",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),

          // --- BUSCADOR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar trámite...",
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF3E77BC)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // --- LISTA DE RESULTADOS (Conectada al Cubit) ---
          Expanded(
            child: BlocBuilder<SubtiposCubit, SubtiposState>(
              builder: (context, state) {
                if (state is SubtiposLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3E77BC)),
                  );
                }

                if (state is SubtiposError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is SubtiposLoaded) {
                  // Filtramos la lista según lo que el usuario escriba
                  final listaFiltrada = state.subtipos.where((item) {
                    return item.subtipoSolicitu.toLowerCase().contains(
                      _searchQuery,
                    );
                  }).toList();

                  if (listaFiltrada.isEmpty) {
                    return const Center(
                      child: Text(
                        "No se encontraron resultados",
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    itemCount: listaFiltrada.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = listaFiltrada[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        // Al tocar un elemento, cerramos el bottom sheet y devolvemos el modelo seleccionado
                        onTap: () => Navigator.pop(context, item),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_document,
                                color: Color(0xFF3E77BC),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.subtipoSolicitu,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
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

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
