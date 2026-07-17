import 'package:flutter/material.dart';

class AsistenciaState extends ChangeNotifier {
  static final AsistenciaState instance = AsistenciaState._internal();
  AsistenciaState._internal();

  final List<Map<String, dynamic>> _hijosConfirmados = [
    {
      'avatarUrl': 'https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?auto=format&fit=crop&q=80&w=150',
      'childName': 'Josue Israel Vasquez',
      'grade': 'Grado 3',
      'group': 'Grupo A',
      'isInSchool': true,
      'statusLabel': 'En la escuela',
      'lastUpdateLabel': 'Última actualización',
      'time': '08:15 AM',
      'statusMessage': 'Entrada a las instalaciones escolares',
    },
    {
      'avatarUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=150',
      'childName': 'Mia Vasquez',
      'grade': 'Grado 1',
      'group': 'Grupo C',
      'isInSchool': false,
      'statusLabel': 'Ya salió',
      'lastUpdateLabel': 'Salida registrada',
      'time': '03:45 PM',
      'statusMessage': 'Salida de las instalaciones escolares',
    },
  ];

  final List<Map<String, dynamic>> _hijosPendientes = [
    {
      'avatarUrl': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&q=80&w=150',
      'childName': 'Mateo Vasquez',
      'grade': 'Grado 5',
      'group': 'Grupo B',
      'schoolName': 'Primaria Red Oak',
      'isInSchool': true,
      'statusLabel': 'En la escuela',
      'lastUpdateLabel': 'Última actualización',
      'time': '07:45 AM',
      'statusMessage': 'Llegó seguro en transporte escolar',
    }
  ];

  List<Map<String, dynamic>> get hijosConfirmados => List.unmodifiable(_hijosConfirmados);
  List<Map<String, dynamic>> get hijosPendientes => List.unmodifiable(_hijosPendientes);

  void confirmarHijo(Map<String, dynamic> hijo) {
    final item = _hijosPendientes.firstWhere(
      (element) => element['childName'] == hijo['childName'],
      orElse: () => {},
    );
    if (item.isNotEmpty) {
      _hijosPendientes.remove(item);
      _hijosConfirmados.add(item);
      notifyListeners();
    }
  }

  void rechazarHijo(Map<String, dynamic> hijo) {
    final item = _hijosPendientes.firstWhere(
      (element) => element['childName'] == hijo['childName'],
      orElse: () => {},
    );
    if (item.isNotEmpty) {
      _hijosPendientes.remove(item);
      notifyListeners();
    }
  }
}
