import 'package:finansale/features/rh/data/models/notas/nota_solicitud_model.dart';

abstract class NotasState {}

class NotasInitial extends NotasState {}

class NotasLoading extends NotasState {}

class NotasLoaded extends NotasState {
  final List<NotaSolicitudModel> notas;
  NotasLoaded(this.notas);
}

class NotasError extends NotasState {
  final String message;
  NotasError(this.message);
}

// Estado clave para limpiar la caja de texto y refrescar el chat tras enviar
class NotaEnviadaExito extends NotasState {}

class NotaEliminadaExito extends NotasState {}
