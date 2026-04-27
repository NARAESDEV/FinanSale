abstract class WorkspaceState {}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceSuccess extends WorkspaceState {}

class WorkspaceError extends WorkspaceState {
  final String message;
  WorkspaceError(this.message);
}
