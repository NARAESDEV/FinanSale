import 'package:finansale/features/auth/data/models/user_model.dart';
import 'package:finansale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:finansale/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/naraes_header.dart';
import '../../../shared/widgets/personalizado_card.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Obtenemos al usuario autenticado desde el Cubit
    final authState = context.watch<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: Text("Sesión no válida")));
    }

    final user = authState.user;

    final modulosPermitidos = user.permisos.where((p) => p.lectura).toList();
    return Scaffold(
      body: Column(
        children: [
          NaraesHeader(
            title: user.nombreCompleto,
            subtitle: user.perfil,
            bottomWidget: null,
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: modulosPermitidos.length,
              itemBuilder: (context, index) {
                final permiso = modulosPermitidos[index];
                return _buildModuloCard(context, permiso);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuloCard(BuildContext context, PermissionModel permiso) {
    // Mapeamos el nombre del string del API a un icono y color
    final config = _getModuloConfig(permiso.modulo);

    return PersonalizadoCard(
      child: InkWell(
        onTap: () {
          if (permiso.modulo == "Recursos Humanos")
            context.push('/rh-dashboard');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(config.icon, color: config.color, size: 40),
            const SizedBox(height: 10),
            Text(
              permiso.modulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para asignar estética según el nombre que venga del backend
  _ModuleConfig _getModuloConfig(String nombre) {
    switch (nombre) {
      case "Recursos Humanos":
        return _ModuleConfig(Icons.groups, const Color(0xFF3E77BC));
      case "Finanzas":
        return _ModuleConfig(Icons.account_balance_wallet, Colors.green);
      case "Clientes":
        return _ModuleConfig(Icons.person_pin_rounded, Colors.orange);
      default:
        return _ModuleConfig(Icons.extension, Colors.grey);
    }
  }
}

class _ModuleConfig {
  final IconData icon;
  final Color color;
  _ModuleConfig(this.icon, this.color);
}
