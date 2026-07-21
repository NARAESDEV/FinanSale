import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finansale/core/auth/session_manager.dart';
import '../state/asistencia_state.dart';

class AsistenciaAjustesPage extends StatefulWidget {
  const AsistenciaAjustesPage({super.key});

  @override
  State<AsistenciaAjustesPage> createState() => _AsistenciaAjustesPageState();
}

class _AsistenciaAjustesPageState extends State<AsistenciaAjustesPage> {
  bool _notificacionesPush = true;
  bool _reportesEmail = false;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const mutedColor = Color(0xFF64748B);
    const blueColor = Color(0xFF3E77BC);

    final mediaQueryData = MediaQuery.of(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Ajustes anti-jank de accesibilidad
    final adjustedMediaQueryData = isIOS
        ? mediaQueryData.copyWith(
            textScaleFactor: mediaQueryData.textScaleFactor.clamp(1.0, 1.15),
          )
        : mediaQueryData;

    Widget pageBody = CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // AppBar premium estilo iOS
        SliverAppBar(
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: primaryColor,
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Ajustes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
          centerTitle: true,
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Tarjeta de Perfil del Tutor
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Antonio Cornelio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tutor Principal / Padre',
                          style: TextStyle(
                            fontSize: 13,
                            color: mutedColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Gestión de Alumnos
              const Text(
                'Gestión de Alumnos',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: mutedColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              // Opción interactiva para verificar y aceptar Hijos
              AnimatedBuilder(
                animation: AsistenciaState.instance,
                builder: (context, _) {
                  final pendingCount = AsistenciaState.instance.hijosPendientes.length;
                  return _buildSettingsTile(
                    icon: Icons.person_add_alt_1_rounded,
                    iconColor: blueColor,
                    title: 'Confirmar Datos de Hijo(s)',
                    subtitle: pendingCount > 0
                        ? '$pendingCount vinculación pendiente'
                        : 'No hay solicitudes pendientes',
                    trailing: pendingCount > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.shade100.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$pendingCount Pendiente',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          )
                        : const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: mutedColor),
                    onTap: pendingCount > 0
                        ? () => context.push('/asistencia/confirmar-hijo')
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No tienes vinculaciones de alumnos pendientes.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Sección: Preferencias
              const Text(
                'Preferencias',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: mutedColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              _buildSettingsTile(
                icon: Icons.notifications_active_rounded,
                iconColor: Colors.amber.shade600,
                title: 'Notificaciones Push',
                subtitle: 'Avisos en tiempo real sobre entradas y salidas.',
                trailing: Switch.adaptive(
                  value: _notificacionesPush,
                  activeColor: blueColor,
                  onChanged: (val) {
                    setState(() {
                      _notificacionesPush = val;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              _buildSettingsTile(
                icon: Icons.alternate_email_rounded,
                iconColor: Colors.purple.shade400,
                title: 'Reportes por Correo',
                subtitle: 'Envío de resumen semanal y mensual.',
                trailing: Switch.adaptive(
                  value: _reportesEmail,
                  activeColor: blueColor,
                  onChanged: (val) {
                    setState(() {
                      _reportesEmail = val;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Soporte
              const Text(
                'Soporte',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: mutedColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              _buildSettingsTile(
                icon: Icons.help_outline_rounded,
                iconColor: Colors.teal.shade500,
                title: 'Ayuda y Centro de Soporte',
                subtitle: 'Preguntas frecuentes y contacto con la escuela.',
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: mutedColor),
                onTap: () {
                  // Acción de ayuda
                },
              ),

              const SizedBox(height: 24),

              // Sección: Sesión
              const Text(
                'Sesión',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: mutedColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              _buildSettingsTile(
                icon: Icons.logout_rounded,
                iconColor: Colors.redAccent,
                title: 'Cerrar sesión',
                subtitle: 'Cierra tu sesión de usuario de forma segura.',
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: mutedColor),
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),

              const SizedBox(height: 48),
            ]),
          ),
        ),
      ],
    );

    // Ajuste responsivo iOS Pro Max
    if (isIOS) {
      pageBody = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: pageBody,
        ),
      );
    }

    return MediaQuery(
      data: adjustedMediaQueryData,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: pageBody,
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const mutedColor = Color(0xFF64748B);
    const redColor = Color(0xFFEF4444);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          '¿Cerrar sesión?',
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
        ),
        content: const Text(
          '¿Estás seguro de que deseas salir? Deberás ingresar tus credenciales nuevamente para acceder.',
          style: TextStyle(color: mutedColor, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: mutedColor, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: redColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              SessionManager.logout(context); // Consumir del SessionManager
            },
            child: const Text(
              'Sí, salir',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
