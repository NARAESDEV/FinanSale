import 'package:finansale/shared/widgets/modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../auth/data/models/user_model.dart';
import '../../auth/presentation/cubit/auth_cubit.dart';
import '../../auth/presentation/cubit/auth_state.dart';
import '../../rh/presentation/cubit/rh_cubit.dart';
import '../../../shared/widgets/naraes_header.dart';
import '../../../shared/widgets/personalizado_card.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    final modulosPermitidos = user.permisos.where((p) => p.lectura).toList();
    return PopScope(
      canPop: true, // Bloqueamos la salida automática
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        // Si intenta salir, disparamos nuestra modal personalizada
        _showLogoutDialog(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // Un gris muy tenue de fondo
        body: Column(
          children: [
            NaraesHeader(
              title: user.nombreCompleto,
              subtitle: user.perfil,
              bottomWidget: null,
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio:
                      0.95, // Ajuste para que las tarjetas no sean tan altas
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
      ),
    );
  }

  Widget _buildModuloCard(BuildContext context, PermissionModel permiso) {
    final config = _getModuloConfig(permiso.modulo);

    return PersonalizadoCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _handleNavigation(context, permiso.modulo),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(config.icon, color: config.color, size: 40),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                permiso.modulo,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Centralizamos la navegación para no ensuciar el widget
  void _handleNavigation(BuildContext context, String modulo) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;
    switch (modulo) {
      case "Recursos Humanos":
        context.read<RhCubit>().getDashboardData(user);
        context.push('/rh-dashboard');

        break;
      case "Clientes":
        context.push('/clientes');
        break;
      case "Finanzas":
        context.push('/finanzas');
        break;
      case "Usuarios":
        context.push('/usuarios');
        break;
      // Agrega aquí los demás casos conforme crees las pantallas
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Módulo $modulo en desarrollo")));
    }
  }

  // Mapeo completo de tu JSON
  _ModuleConfig _getModuloConfig(String nombre) {
    switch (nombre) {
      case "Oportunidades":
        return _ModuleConfig(Icons.lightbulb_outline, Colors.amber.shade700);
      case "Unidad de negocio":
        return _ModuleConfig(Icons.business_center_outlined, Colors.indigo);
      case "Recursos Humanos":
        return _ModuleConfig(Icons.groups_outlined, const Color(0xFF3E77BC));
      case "Usuarios":
        return _ModuleConfig(Icons.person_add_alt_1_outlined, Colors.teal);
      case "Productos":
        return _ModuleConfig(Icons.inventory_2_outlined, Colors.deepPurple);
      case "Clientes":
        return _ModuleConfig(Icons.person_pin_rounded, Colors.orange.shade800);
      case "Compras":
        return _ModuleConfig(Icons.shopping_cart_outlined, Colors.redAccent);
      case "Proveedores":
        return _ModuleConfig(Icons.local_shipping_outlined, Colors.brown);
      case "Mercancías":
        return _ModuleConfig(Icons.widgets_outlined, Colors.blueGrey);
      case "Logistica y distribución":
        return _ModuleConfig(Icons.map_outlined, Colors.cyan.shade700);
      case "Finanzas":
        return _ModuleConfig(
          Icons.account_balance_wallet_outlined,
          Colors.green.shade700,
        );
      default:
        return _ModuleConfig(Icons.extension_outlined, Colors.grey);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Obliga a elegir una opción
      builder: (context) => ModalDialog(
        title: "Cerrar Sesión",
        message:
            "¿Estás seguro de que quieres salir? Tendrás que ingresar tus credenciales de nuevo.",
        type: DialogType.warning, // Usamos warning para el logout
        confirmText: "Sí, salir",
        cancelText: "Cancelar",
        onConfirm: () {
          context.read<AuthCubit>().logout();
          context.go('/login');
        },
      ),
    );
  }
}

class _ModuleConfig {
  final IconData icon;
  final Color color;
  _ModuleConfig(this.icon, this.color);
}
