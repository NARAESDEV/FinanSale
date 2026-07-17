import 'package:flutter/material.dart';
import '../widgets/collapsing_student_header.dart';
import '../widgets/activity_timeline.dart';
import '../widgets/badge_reinforcement_card.dart';

class ChildDetailAsistenciaPage extends StatelessWidget {
  final String childName;
  final String avatarUrl;
  final String grade;
  final String schoolName;
  final bool? isInSchool;
  final String? time;
  final String? statusMessage;
  final List<AsistenciaActivity>? mockActivities;

  const ChildDetailAsistenciaPage({
    super.key,
    this.childName = 'Leo Harrison',
    this.avatarUrl =
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=150',
    this.grade = 'Grado 4',
    this.schoolName = 'Primaria Red Oak',
    this.isInSchool,
    this.time,
    this.statusMessage,
    this.mockActivities,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Control de jank visual / escala de texto para iOS
    final adjustedMediaQueryData = isIOS
        ? mediaQueryData.copyWith(
            textScaleFactor: mediaQueryData.textScaleFactor.clamp(1.0, 1.15),
          )
        : mediaQueryData;

    // Construcción dinámica de actividades según el estado real del niño
    List<AsistenciaActivity> activities = [];

    if (mockActivities != null) {
      activities = mockActivities!;
    } else if (isInSchool != null) {
      if (isInSchool!) {
        // En la escuela: solo tiene marcaje de Entrada (Llegada)
        activities = [
          AsistenciaActivity(
            title: 'Llegada',
            time: time ?? '08:15 AM',
            description:
                statusMessage ?? 'Entrada a las instalaciones escolares',
            isArrival: true,
          ),
        ];
      } else {
        // Fuera de la escuela: tiene Entrada y Salida
        activities = [
          const AsistenciaActivity(
            title: 'Llegada',
            time: '07:30 AM',
            description: 'Entrada a las instalaciones escolares',
            isArrival: true,
          ),
          AsistenciaActivity(
            title: 'Salida de la escuela',
            time: time ?? '03:45 PM',
            description:
                statusMessage ?? 'Salida de las instalaciones escolares',
            isArrival: false,
          ),
        ];
      }
    } else {
      // Fallback por defecto
      activities = const [
        AsistenciaActivity(
          title: 'Llegada',
          time: '07:28 AM',
          description:
              'Ingresó por la Puerta Principal A. Control de temperatura completado.',
          isArrival: true,
        ),
        AsistenciaActivity(
          title: 'Salida de la escuela',
          time: '02:14 PM',
          description:
              'Salió por la zona de autobuses. Registrado por la supervisora Sarah J.',
          isArrival: false,
        ),
      ];
    }

    Widget pageBody = CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Cabecera animada colapsable estilo iOS
        SliverPersistentHeader(
          pinned: true,
          delegate: CollapsingStudentHeader(
            childName: childName,
            avatarUrl: avatarUrl,
            grade: grade,
            schoolName: schoolName,
          ),
        ),

        // 2. Contenido de la actividad diaria y reforzamiento
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 32.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Actividades de hoy
              ActivityTimeline(
                activities: activities,
                dateText: '24 de octubre de 2026',
              ),

              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 24),

              // Historial - Ayer
              const ActivityTimeline(
                activities: [
                  AsistenciaActivity(
                    title: 'Llegada',
                    time: '07:25 AM',
                    description:
                        'Ingresó por la Puerta Principal A. Control de temperatura completado.',
                    isArrival: true,
                  ),
                  AsistenciaActivity(
                    title: 'Salida de la escuela',
                    time: '02:10 PM',
                    description:
                        'Salió por la zona de autobuses. Registrado por la supervisora Sarah J.',
                    isArrival: false,
                  ),
                ],
                dateText: 'Ayer, 23 Oct',
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 24),

              // Historial - Antier
              const ActivityTimeline(
                activities: [
                  AsistenciaActivity(
                    title: 'Llegada',
                    time: '07:30 AM',
                    description: 'Ingresó por la Puerta Principal A.',
                    isArrival: true,
                  ),
                  AsistenciaActivity(
                    title: 'Salida de la escuela',
                    time: '02:15 PM',
                    description: 'Salió por la zona de autobuses.',
                    isArrival: false,
                  ),
                ],
                dateText: 'Jueves, 22 Oct',
              ),
              const SizedBox(height: 32),

              // Tarjeta motivacional inferior
              BadgeReinforcementCard(
                title: 'Excelente Asistencia',
                description:
                    '$childName ha llegado puntual durante 15 días consecutivos.',
              ),
            ]),
          ),
        ),
      ],
    );

    // Constreñimos a 480px máximo en iOS para pantallas anchas de iPhone (Pro Max)
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
        backgroundColor: const Color(
          0xFFF8FAFC,
        ), // Fondo sutilmente grisáceo para resaltar tarjetas blancas
        body: pageBody,
      ),
    );
  }
}
