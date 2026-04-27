import '../../data/models/subtipo_solicitud_model.dart';
import '../../../auth/data/models/user_model.dart';

abstract class RhRepository {
  /// Obtiene la lista de subtipos de solicitud desde el backend
  Future<List<SubtipoSolicitudModel>> getSubtiposSolicitud(UserModel user);
}
