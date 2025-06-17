import 'package:ggym/shared/flutter_flow/flutter_flow_icon_button.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_theme.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_util.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:ggym/shared/flutter_flow/random_data_util.dart' as random_data;
import 'gestionar_perfil_widget.dart' show GestionarPerfilWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GestionarPerfilModel extends FlutterFlowModel<GestionarPerfilWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
