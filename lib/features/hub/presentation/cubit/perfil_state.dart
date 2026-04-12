import 'package:finansale/features/hub/data/model/perfil_model.dart';

abstract class PerfilState {}

class PerfilLoading extends PerfilState {}

class PerfilLoaded extends PerfilState {
  final PerfilModel perfil;
  PerfilLoaded(this.perfil);
}

class PerfilError extends PerfilState {
  final String message;
  PerfilError(this.message);
}
