import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../state/asistencia_state.dart';

class ConfirmarHijoPage extends StatefulWidget {
  const ConfirmarHijoPage({super.key});

  @override
  State<ConfirmarHijoPage> createState() => _ConfirmarHijoPageState();
}

class _ConfirmarHijoPageState extends State<ConfirmarHijoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _successController;
  late Animation<double> _scaleAnimation;
  bool _showSuccessOverlay = false;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  void _onConfirm(Map<String, dynamic> hijo) {
    setState(() {
      _showSuccessOverlay = true;
    });
    _successController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          AsistenciaState.instance.confirmarHijo(hijo);
          // Retornamos al dashboard o ajustes
          context.pop();
        }
      });
    });
  }

  void _onReject(Map<String, dynamic> hijo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Reportar como incorrecto?'),
        content: const Text(
          'Si confirmas que este no es tu hijo, se eliminará la vinculación de tu cuenta y se notificará a soporte escolar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              AsistenciaState.instance.rechazarHijo(hijo);
              context.pop(); // Salir de la página de confirmación
            },
            child: const Text('Sí, no es mi hijo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const mutedColor = Color(0xFF64748B);
    const blueColor = Color(0xFF3E77BC);

    final mediaQueryData = MediaQuery.of(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final adjustedMediaQueryData = isIOS
        ? mediaQueryData.copyWith(
            textScaleFactor: mediaQueryData.textScaleFactor.clamp(1.0, 1.15),
          )
        : mediaQueryData;

    // Tomamos el primer hijo pendiente para la UI
    final pendientes = AsistenciaState.instance.hijosPendientes;
    if (pendientes.isEmpty) {
      return Scaffold(
        appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
        body: const Center(child: Text('No hay vinculaciones pendientes.')),
      );
    }
    final hijo = pendientes.first;

    Widget pageBody = Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
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
                'Confirmación de Hijo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
              centerTitle: true,
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Banner motivacional superior
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: blueColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Se ha detectado una nueva solicitud de vinculación desde la administración escolar.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tarjeta Principal del Alumno
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.08),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar circular grande
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: blueColor.withValues(alpha: 0.2),
                              width: 4,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              hijo['avatarUrl'] ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          hijo['childName'] ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          hijo['grade'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Datos de escuela / grupo
                        _buildDetailRow(
                          'Grupo',
                          hijo['group'] ?? '',
                          Icons.group_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Escuela',
                          hijo['schoolName'] ?? 'Primaria Red Oak',
                          Icons.school_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Relación',
                          'Hijo / Tutorado',
                          Icons.family_restroom_outlined,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Texto de pregunta
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '¿Confirmas que los datos mostrados corresponden a tu hijo/a?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: mutedColor,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botones de acción animables y con gestos premium
                  Column(
                    children: [
                      // Botón Aceptar (Confirmar)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blueColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => {},
                          // onPressed: () => _onConfirm(hijo),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle_outline_rounded,
                              //   size: 20,
                              // ),
                              SizedBox(width: 10),
                              // Text(
                              //   'Sí, es mi hijo/a y confirmo',
                              //   style: TextStyle(
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Botón Rechazar (No es mi hijo)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => _onReject(hijo),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.error_outline_rounded, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Este NO es mi hijo/a',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ]),
              ),
            ),
          ],
        ),

        // Overlay de Éxito con micro-animaciones premium
        if (_showSuccessOverlay)
          Container(
            color: Colors.black.withValues(alpha: 0.6),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 72,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '¡Hijo Vinculado!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'El alumno ha sido vinculado a tu cuenta correctamente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: mutedColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );

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
      child: Scaffold(backgroundColor: const Color(0xFFF8FAFC), body: pageBody),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF64748B), size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
