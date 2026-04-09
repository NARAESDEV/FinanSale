import '../../data/models/rh_dashboard_model.dart';

abstract class RhState {}

class RhLoading extends RhState {}

class RhLoaded extends RhState {
  final RhDashboardModel dashboardData;
  RhLoaded(this.dashboardData);
}

class RhError extends RhState {
  final String message;
  RhError(this.message);
}
