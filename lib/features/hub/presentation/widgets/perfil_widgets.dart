import 'package:finansale/core/theme/theme_cubit.dart';
import 'package:finansale/features/hub/data/model/perfil_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/personalizado_card.dart';

class PerfilHeader extends StatelessWidget {
  final PerfilModel perfil;
  const PerfilHeader({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar optimizado sin ClipRRect
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEFF5FF),
            border: Border.all(
              color: const Color(0xFF3E77BC).withValues(alpha: 0.2),
              width: 3,
            ),
          ),
          child: const Center(
            child: Icon(Icons.person, size: 50, color: Color(0xFF3E77BC)),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          perfil.nombreCompleto,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          perfil.correo,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
        // Placa (Badge) de la empresa
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            perfil.empresa.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.surface,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class InfoLaboralCard extends StatelessWidget {
  final PerfilModel perfil;
  const InfoLaboralCard({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    return PersonalizadoCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Información Laboral",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildRow(
              context,
              Icons.work_outline_rounded,
              "Puesto / Cargo",
              perfil.perfil,
            ),
            const Divider(height: 30),
            _buildRow(context, Icons.domain_rounded, "Empresa", perfil.empresa),
            const Divider(height: 30),
            _buildRow(
              context,
              Icons.calendar_today_rounded,
              "Fecha de Ingreso",
              perfil.fechaIngreso,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF3E77BC), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VacacionesCard extends StatelessWidget {
  final PerfilModel perfil;
  const VacacionesCard({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    return PersonalizadoCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Balance de Vacaciones",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: "Días Totales",
                    value: perfil.diasTotalesVacaciones.toString(),
                    bgColor: const Color(0xFFEFF6FF),
                    textColor: const Color(0xFF3E77BC),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    label: "Restantes",
                    value: perfil.diasRestantesVacaciones.toString(),
                    bgColor: const Color(0xFFECFDF5),
                    textColor: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;
  final Color textColor;

  const _StatBox({
    required this.label,
    required this.value,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfiguracionCard extends StatelessWidget {
  const ConfiguracionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonalizadoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              "Configuración de la Cuenta",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          _ActionRow(
            icon: Icons.lock_outline_rounded,
            label: "Cambiar Contraseña",
            onTap: () {},
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _ActionRow(
            icon: Icons.dark_mode_outlined,
            label: "Modo Oscuro",
            trailing: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) => Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (_) => context.read<ThemeCubit>().toggle(),
                activeColor: const Color(0xFF3E77BC),
              ),
            ),
            onTap: () => context.read<ThemeCubit>().toggle(),
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _ActionRow(
            icon: Icons.logout_rounded,
            label: "Cerrar Sesión",
            iconColor: const Color(0xFFEF4444),
            textColor: const Color(0xFFEF4444),
            showArrow: false,
            onTap: () {
              // Tu lógica de logout
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    this.iconColor,
    this.textColor,
    this.trailing,
    this.showArrow = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? const Color(0xFF3E77BC), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showArrow)
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFCBD5E1),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
