import 'dart:ui';
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
  bool _showOverlay = false;
  bool _isConfirmSuccess = true;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
      _showOverlay = true;
      _isConfirmSuccess = true;
    });
    _successController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          AsistenciaState.instance.confirmarHijo(hijo);
          context.pop();
        }
      });
    });
  }

  void _onReject(Map<String, dynamic> hijo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return _RejectionBottomSheet(
          hijo: hijo,
          onConfirm: (reason, comment) {
            _showRejectionSuccessAnimation(hijo, reason, comment);
          },
        );
      },
    );
  }

  void _showRejectionSuccessAnimation(
    Map<String, dynamic> hijo,
    String reason,
    String comment,
  ) {
    setState(() {
      _showOverlay = true;
      _isConfirmSuccess = false;
    });
    _successController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          AsistenciaState.instance.rechazarHijo(hijo);
          context.pop();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const mutedColor = Color(0xFF64748B);
    const blueColor = Color(0xFF3E77BC);

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final textScaler = MediaQuery.textScalerOf(context);
    final adjustedTextScaler = isIOS ? TextScaler.noScaling : textScaler;

    // Tomamos el primer hijo pendiente para la UI
    final pendientes = AsistenciaState.instance.hijosPendientes;
    if (pendientes.isEmpty) {
      return Scaffold(
        appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
        body: const Center(
          child: Text(
            'No hay vinculaciones pendientes.',
            style: TextStyle(color: mutedColor, fontSize: 16),
          ),
        ),
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
                  // Banner informativo superior
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
                              color: const Color(0xFF475569),
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
                        // Avatar circular grande con borde de estado
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
                          onPressed: () => _onConfirm(hijo),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Sí, es mi hijo/a y confirmo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Icon(Icons.error_outline_rounded, size: 20),
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

        // Overlay de Éxito / Rechazo con desenfoque de fondo Glassmorphic
        if (_showOverlay)
          Container(
            color: Colors.black.withValues(alpha: 0.45),
            width: double.infinity,
            height: double.infinity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 290,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isConfirmSuccess
                              ? Icons.check_circle_rounded
                              : Icons.report_gmailerrorred_rounded,
                          color: _isConfirmSuccess
                              ? Colors.green
                              : Colors.redAccent,
                          size: 76,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _isConfirmSuccess
                              ? '¡Hijo Vinculado!'
                              : 'Reporte Enviado',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isConfirmSuccess
                              ? 'El alumno ha sido vinculado a tu cuenta correctamente.'
                              : 'Se ha notificado al soporte y cancelado la vinculación.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
      data: MediaQueryData(
        size: MediaQuery.sizeOf(context),
        padding: MediaQuery.paddingOf(context),
        viewInsets: EdgeInsets.zero, // Fijamos los insets en cero para que la página principal ignore el teclado y no se reconstruya
        textScaler: adjustedTextScaler,
        devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
        platformBrightness: MediaQuery.platformBrightnessOf(context),
        systemGestureInsets: MediaQuery.systemGestureInsetsOf(context),
        viewPadding: MediaQuery.viewPaddingOf(context),
        gestureSettings: MediaQuery.gestureSettingsOf(context),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Totalmente inmune al redimensionamiento por teclado
        backgroundColor: const Color(0xFFF8FAFC), 
        body: pageBody,
      ),
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

// Bottom Sheet de reporte e inconsistencia premium
class _RejectionBottomSheet extends StatefulWidget {
  final Map<String, dynamic> hijo;
  final Function(String reason, String comment) onConfirm;

  const _RejectionBottomSheet({required this.hijo, required this.onConfirm});

  @override
  State<_RejectionBottomSheet> createState() => _RejectionBottomSheetState();
}

class _RejectionBottomSheetState extends State<_RejectionBottomSheet> {
  String? _selectedReason;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, String>> _reasons = [
    {
      'id': 'not_my_child',
      'title': 'Este no es mi hijo/a',
      'subtitle': 'No reconozco a este estudiante en mi familia.',
    },
    {
      'id': 'wrong_info',
      'title': 'Información incorrecta',
      'subtitle': 'El nombre, grado, grupo o datos están erróneos.',
    },
    // {
    //   'id': 'wrong_school',
    //   'title': 'Institución incorrecta',
    //   'subtitle': 'La escuela o campus asignado no es el correcto.',
    // },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const mutedColor = Color(0xFF64748B);
    const redColor = Color(0xFFEF4444);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header
              const Text(
                'Reportar Inconsistencia',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Indícanos por qué rechazas la vinculación de este alumno para notificar al soporte de la escuela.',
                style: TextStyle(fontSize: 13, color: mutedColor, height: 1.4),
              ),
              const SizedBox(height: 20),

              // Lista de motivos personalizados (Radio Cards)
              ..._reasons.map((reason) {
                final isSelected = _selectedReason == reason['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedReason = reason['id'];
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? redColor.withValues(alpha: 0.04)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? redColor : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reason['title']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? redColor : primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  reason['subtitle']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: mutedColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: isSelected ? redColor : mutedColor,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 8),

              // Campo de descripción / "Reporta aquí"
              const Text(
                'Reportar detalles adicionales',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                focusNode: _focusNode,
                maxLines: 3,
                style: const TextStyle(fontSize: 14, color: primaryColor),
                decoration: InputDecoration(
                  hintText:
                      'Describe la inconsistencia o ingresa los datos correctos de tu hijo...',
                  hintStyle: const TextStyle(fontSize: 13, color: mutedColor),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: redColor, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: mutedColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _selectedReason == null
                          ? null
                          : () {
                              Navigator.pop(context);
                              widget.onConfirm(
                                _selectedReason!,
                                _commentController.text,
                              );
                            },
                      child: const Text(
                        'Enviar y Rechazar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
