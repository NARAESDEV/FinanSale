import '../../../auth/data/models/user_model.dart';
import '../../data/models/subtipo_solicitud_model.dart';
import '../../data/models/tipo_solicitud_model.dart';

abstract class RhRepository {
  // 1. Obtener Tipos (Vacaciones, Permisos, etc)
  Future<List<TipoSolicitudModel>> getTiposSolicitud(UserModel user);

  // 2. Obtener Subtipos dependiendo del ID
  Future<List<SubtipoSolicitudModel>> getSubtiposPorTipo(
    UserModel user,
    int idTipoSolicitud,
  );
}
