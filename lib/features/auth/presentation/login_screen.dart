import 'package:finansale/shared/widgets/modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Importaciones de tu arquitectura
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

// --- NUEVOS IMPORTS PARA WORKSPACE ---
import '../../../../shared/services/storage_service.dart';
import '../../../../core/network/dio_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. CONTROLADORES
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. ESTADO DEL WORKSPACE
  bool _showUrlField = true;

  @override
  void initState() {
    super.initState();
    _checkExistingWorkspace();
  }

  // --- LÓGICA DE PERSISTENCIA ---
  Future<void> _checkExistingWorkspace() async {
    final savedUrl = await StorageService.instance.getWorkspace();

    if (savedUrl != null && mounted) {
      setState(() {
        _urlController.text = savedUrl;
        _showUrlField = false; // Ocultamos el campo porque ya existe
      });
      // Pre-configuramos Dio por si el Cubit lo necesita antes de tiempo
      DioClient.setBaseUrl(savedUrl);
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 80),

              // --- LOGO (INTACTO) ---
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.cloud_queue,
                    size: 100,
                    color: Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "FinanSale",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E77BC),
                ),
              ),

              const SizedBox(height: 60),

              // --- NUEVO CAMPO: URL DEL SERVIDOR (CONDICIONAL) ---
              if (_showUrlField) ...[
                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "URL del Servidor (ej. https://api.empresa.com)",
                    hintStyle: const TextStyle(color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: const Color(0xFFF9FCFF),
                    prefixIcon: const Icon(
                      Icons.lan_rounded,
                      color: Color(0xFF3E77BC),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // --- CAMPO: CORREO ELECTRÓNICO ---
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Correo electrónico",
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFFF9FCFF),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF3E77BC),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- CAMPO: CONTRASEÑA ---
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFFF9FCFF),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF3E77BC),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                ),
              ),

              // --- OLVIDASTE CONTRASEÑA ---
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      color: Color(0xFF3E77BC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- BOTÓN ENTRAR (CONECTADO AL CUBIT) ---
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    context.go('/hub');
                  }
                  if (state is AuthError) {
                    showDialog(
                      context: context,
                      builder: (context) => ModalDialog(
                        title: "¡Ups! Algo falló",
                        message: state.message,
                        type: DialogType.error,
                        confirmText: "Entendido",
                        onConfirm: () => Navigator.pop(context),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              // Validamos rápidamente que la URL no esté vacía si está visible
                              if (_urlController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "La URL del servidor es obligatoria",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // AHORA ENVIAMOS LOS 3 PARÁMETROS AL CUBIT
                              context.read<AuthCubit>().login(
                                url: _urlController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E77BC),
                        disabledBackgroundColor: const Color(
                          0xFF3E77BC,
                        ).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Entrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),

              // --- BOTÓN PARA CAMBIAR SERVIDOR (Si ya estaba oculto) ---
              if (!_showUrlField) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showUrlField = true;
                    });
                  },
                  icon: const Icon(
                    Icons.settings_ethernet_rounded,
                    color: Color(0xFF64748B),
                    size: 18,
                  ),
                  label: const Text(
                    "Cambiar servidor de trabajo",
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
