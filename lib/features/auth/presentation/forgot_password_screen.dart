import 'package:finansale/shared/widgets/input_personalizado.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/naraes_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NaraesHeader(
            title: "Recuperar",
            subtitle: "Ingresa tu correo para enviarte instrucciones",
            isCompact: true,
            onBack: () => context.pop(), // GoRouter para volver atrás
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const InputPersonalizado(
                    label: "Correo Electrónico",
                    hint: "tucorreo@empresa.com",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para enviar correo
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E77BC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "ENVIAR INSTRUCCIONES",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
