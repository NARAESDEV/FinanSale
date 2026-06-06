import 'package:finansale/core/utils/attachment_helper.dart';
import 'package:finansale/features/rh/presentation/cubit/notas/notas_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/notas/notas_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class NotasChatSheet extends StatefulWidget {
  final int idSolicitud;
  const NotasChatSheet({super.key, required this.idSolicitud});

  static void show(BuildContext context, int idSolicitud) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que suba cuando se abre el teclado
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider<NotasCubit>(
        create: (context) {
          final cubit = NotasCubit();
          final authState = context.read<AuthCubit>().state;
          if (authState is AuthAuthenticated) {
            cubit.getNotasSolicitud(authState.user, idSolicitud);
          }
          return cubit;
        },
        child: NotasChatSheet(idSolicitud: idSolicitud),
      ),
    );
  }

  @override
  State<NotasChatSheet> createState() => _NotasChatSheetState();
}

class _NotasChatSheetState extends State<NotasChatSheet> {
  final TextEditingController _textController = TextEditingController();
  AttachmentResult? _adjuntoSeleccionado;
  bool _estaEnviando = false;
  bool _cargandoAdjunto = false;
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Ejecuta la acción de adjuntar archivo usando nuestro helper sin errores
  Future<void> _capturarAdjunto() async {
    if (_cargandoAdjunto || _estaEnviando) return;

    setState(() {
      _cargandoAdjunto = true; // Enciende el estado de carga
    });

    try {
      final result = await AttachmentHelper.seleccionarAdjunto();
      if (result != null) {
        setState(() {
          _adjuntoSeleccionado = result;
        });
      }
    } catch (e) {
      debugPrint("Error al procesar el archivo local: $e");
    } finally {
      setState(() {
        _cargandoAdjunto = false; // 🔒 SEGURO: Apaga el loader pase lo que pase
      });
    }
  }

  void _enviarMensaje() {
    // Si la caja está vacía y no hay archivos, o si ya hay un proceso en curso, abortamos
    if ((_textController.text.trim().isEmpty && _adjuntoSeleccionado == null) ||
        _estaEnviando ||
        _cargandoAdjunto)
      return;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        _estaEnviando = true; // Congela el botón para evitar clics repetidos
      });

      context.read<NotasCubit>().enviarNota(
        user: authState.user,
        idSolicitud: widget.idSolicitud,
        // Si el texto está vacío pero hay adjunto, mandamos un texto descriptivo automático
        contenido: _textController.text.trim().isEmpty
            ? "Adjunto enviado: ${_adjuntoSeleccionado!.nombre}"
            : _textController.text.trim(),
        nombreAdjunto: _adjuntoSeleccionado?.nombre,
        tamanioAdjunto: _adjuntoSeleccionado?.tamanio,
        adjuntoBase64: _adjuntoSeleccionado?.base64,
      );

      _textController.clear();
      setState(() {
        _adjuntoSeleccionado = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mediaquery para ajustar el alto cuando el teclado nativo se despliega
    final paddingBottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height:
          MediaQuery.of(context).size.height *
          0.75, // Ocupa el 75% de la pantalla
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Barra superior decorativa del modal
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "BITÁCORA DE NOTAS Y EVIDENCIAS",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Color(0xFF1E293B),
              letterSpacing: 0.5,
            ),
          ),
          const Divider(height: 24),

          // LISTADO DE MENSAJES (CONVERSACIÓN)
          Expanded(
            child: BlocConsumer<NotasCubit, NotasState>(
              buildWhen: (previous, current) {
                return current is NotasLoading || current is NotasLoaded;
              },
              listener: (context, state) {
                if (state is NotaEnviadaExito) {
                  // Si se envió con éxito, refrescamos la lista automáticamente
                  final authState = context.read<AuthCubit>().state;
                  if (authState is AuthAuthenticated) {
                    context.read<NotasCubit>().getNotasSolicitud(
                      authState.user,
                      widget.idSolicitud,
                    );
                  }
                }
                if (state is NotaEliminadaExito) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Nota eliminada de la bitácora"),
                      backgroundColor: Color(0xFFEF4444),
                    ),
                  );
                  final authState = context.read<AuthCubit>().state;
                  if (authState is AuthAuthenticated) {
                    context.read<NotasCubit>().getNotasSolicitud(
                      authState.user,
                      widget.idSolicitud,
                    );
                  }
                }
              },

              builder: (context, state) {
                if (state is NotasLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3E77BC)),
                  );
                }
                if (state is NotasError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                if (state is NotasLoaded) {
                  if (state.notas.isEmpty) {
                    return Center(
                      child: Text(
                        "No hay notas ni comentarios en este trámite.",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    reverse:
                        true, // Los mensajes nuevos se acumulan abajo de forma natural
                    itemCount: state.notas.length,
                    itemBuilder: (context, index) {
                      // Invertimos el index para el comportamiento reverse
                      final nota = state.notas[state.notas.length - 1 - index];

                      // Identificamos si el mensaje es del usuario logueado actualmente
                      final authState = context.read<AuthCubit>().state;
                      final bool miMensaje =
                          authState is AuthAuthenticated &&
                          authState.user.idUsuario == nota.idUsuarioCr;

                      return _buildGloboMensaje(nota, miMensaje);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          if (_cargandoAdjunto)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFFF8FAFC), // Fondo premium gris suave
              child: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Color(0xFF3E77BC), // Tu azul corporativo
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Procesando y cifrando archivo para la bitácora...",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // SLOT VISUAL DE ARCHIVO SELECCIONADO (PREVIEW ANTES DE ENVIAR)
          if (_adjuntoSeleccionado != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF1F5F9),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file_rounded,
                    color: Color(0xFF3E77BC),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _adjuntoSeleccionado!.nombre,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    "${_adjuntoSeleccionado!.tamanio} KB",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _adjuntoSeleccionado = null),
                  ),
                ],
              ),
            ),

          // CAJA DE TEXTO INFERIOR (INPUT BAR)
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: paddingBottom + 16,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: (_cargandoAdjunto || _estaEnviando)
                      ? Colors.grey[200]
                      : const Color(0xFFF1F5F9),
                  child: IconButton(
                    icon: Icon(
                      Icons.attach_file_rounded,
                      color: (_cargandoAdjunto || _estaEnviando)
                          ? Colors.grey[400]
                          : const Color(0xFF64748B),
                    ),
                    // Si está ocupado, el onPressed se vuelve null desactivando el botón por completo
                    onPressed: (_cargandoAdjunto || _estaEnviando)
                        ? null
                        : _capturarAdjunto,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (_) => _enviarMensaje(),
                    decoration: InputDecoration(
                      hintText: "Escribe un comentario o aclaración...",
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: const Color(0xFF3E77BC),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: _enviarMensaje,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DISEÑO PREMIUM DE LOS GLOBOS DE CONVERSACIÓN
  Widget _buildGloboMensaje(dynamic nota, bool miMensaje) {
    final Color fondoGlobo = miMensaje
        ? const Color(0xFFE0F2FE)
        : const Color(0xFFF1F5F9);
    final Color colorTexto = miMensaje
        ? const Color(0xFF0369A1)
        : const Color(0xFF1E293B);

    return GestureDetector(
      onLongPress: () => _mostrarMenuOpciones(context, nota, miMensaje),
      child: Align(
        alignment: miMensaje ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: fondoGlobo,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(miMensaje ? 16 : 0),
              bottomRight: Radius.circular(miMensaje ? 0 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del creador de la nota
              Text(
                nota.usuarioCreador,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: miMensaje
                      ? const Color(0xFF0284C7)
                      : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),

              // 🚀 RENDERIZADOR HTML: Renderiza negritas y etiquetas de Flask nativamente
              HtmlWidget(
                nota.contenido,
                textStyle: TextStyle(
                  fontSize: 13,
                  color: colorTexto,
                  height: 1.3,
                ),
              ),

              // Si la nota contiene un archivo adjunto guardado en Flask, pintamos un chip indicador
              if (nota.nombreAdjunto != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.file_present_rounded,
                        size: 16,
                        color: Color(0xFF3E77BC),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          nota.nombreAdjunto!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 NUEVA FUNCIÓN: Despliega opciones al mantener oprimido el globo
  void _mostrarMenuOpciones(
    BuildContext context,
    dynamic nota,
    bool miMensaje,
  ) {
    // Si no es mi mensaje, no permitimos la eliminación (Regla de negocio)
    if (!miMensaje) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "OPCIONES DE MENSAJE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 16),

              // BOTÓN ELIMINAR OPCIÓN PREMIUM
              ListTile(
                leading: const Icon(
                  Icons.delete_sweep_rounded,
                  color: Color(0xFFEF4444),
                ),
                title: const Text(
                  "Eliminar nota definitivamente",
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.pop(modalContext); // Cierra el menú de opciones

                  final authState = context.read<AuthCubit>().state;
                  if (authState is AuthAuthenticated) {
                    // Dispara el DELETE en Flask pasándole el idNota real del JSON
                    context.read<NotasCubit>().eliminarNota(
                      authState.user,
                      nota.idNota,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
