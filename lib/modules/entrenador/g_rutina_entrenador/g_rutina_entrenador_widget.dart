import 'package:ggym/shared/flutter_flow/flutter_flow_icon_button.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_theme.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_util.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:ggym/shared/flutter_flow/random_data_util.dart' as random_data;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'g_rutina_entrenador_model.dart';
export 'g_rutina_entrenador_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class GRutinaEntrenadorWidget extends StatefulWidget {
  const GRutinaEntrenadorWidget({super.key});

  static String routeName = 'gRutinaEntrenador';
  static String routePath = '/gRutinaEntrenador';

  @override
  State<GRutinaEntrenadorWidget> createState() =>
      _GRutinaEntrenadorWidgetState();
}

class _GRutinaEntrenadorWidgetState extends State<GRutinaEntrenadorWidget> {
  late GRutinaEntrenadorModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String serverIP = 'http://127.0.0.1:5000'; // o http://192.168.X.X:5000

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GRutinaEntrenadorModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  Future<List<Map<String, dynamic>>> obtenerRutinasEntrenador() async {
    final url = Uri.parse('$serverIP/rutinas_entrenador');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<Map<String, dynamic>>((item) => {
          'entrenador_id': item['entrenador_id'],
          'nombre_rutina': item['nombre_rutina'],
          'descripcion': item['descripcion'],
        }).toList();
      } else {
        throw Exception('Error al obtener rutinas');
      }
    } catch (e) {
      print('Error en obtenerRutinasEntrenador(): $e');
      return [];
    }
  }

  Future<bool> enviarRutinaAlServidor({
    required String nombreRutina,
    required String descripcion,
  }) async {
    final url = Uri.parse('$serverIP/rutinas'); // Asegúrate de tener tu IP correcta

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'entrenador_id': 1, // ID fijo como mencionaste
          'nombre_rutina': nombreRutina,
          'descripcion': descripcion,
        }),
      );

      if (response.statusCode == 201) {
        print('✅ Rutina guardada correctamente');
        return true;
      } else {
        print('❌ Error al guardar rutina: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error en enviarRutinaAlServidor: $e');
      return false;
    }
  }

  // --- INICIO DE LA FUNCIÓN _mostrarCrearRutinaDialog (Diálogo Principal SIMPLIFICADO) ---
  Future<void> _mostrarCrearRutinaDialog(BuildContext context) async {
    TextEditingController nombreRutinaController = TextEditingController();
    TextEditingController descripcionRutinaController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: AlignmentDirectional(1.0, -1.0),
                    child: InkWell(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 20.0),
                    child: Text(
                      'Crear Nueva Rutina',
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: GoogleFonts.interTight().fontFamily,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  // Campo: Nombre de la Rutina
                  TextFormField(
                    controller: nombreRutinaController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la Rutina',
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 2.0),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2.0),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).alternate,
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    cursorColor: FlutterFlowTheme.of(context).primary,
                  ),
                  SizedBox(height: 16.0),

                  // Campo: Descripción de la Rutina
                  TextFormField(
                    controller: descripcionRutinaController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Descripción de la Rutina',
                      alignLabelWithHint: true,
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 2.0),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2.0),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).alternate,
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    cursorColor: FlutterFlowTheme.of(context).primary,
                  ),
                  SizedBox(height: 24.0),

                  // Botón para guardar la rutina
                  FFButtonWidget(
                    onPressed: () async {
                      String nombreRutina = nombreRutinaController.text.trim();
                      String descripcionRutina = descripcionRutinaController.text.trim();

                      if (nombreRutina.isEmpty || descripcionRutina.isEmpty) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, completa todos los campos.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Enviar al servidor
                      bool exito = await enviarRutinaAlServidor(
                        nombreRutina: nombreRutina,
                        descripcion: descripcionRutina,
                      );

                      if (exito) {
                        Navigator.pop(dialogContext); // Cierra el diálogo si fue exitoso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rutina guardada correctamente.')),
                        );
                      } else {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Hubo un problema al guardar la rutina.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    text: 'Guardar Rutina',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: GoogleFonts.interTight().fontFamily,
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                      elevation: 3.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Liberar los controladores al cerrar el diálogo principal
    nombreRutinaController.dispose();
    descripcionRutinaController.dispose();
  }
  // --- FIN DE LA FUNCIÓN _mostrarCrearRutinaDialog ---

  Future<List<Map<String, dynamic>>> obtenerRutinasSimuladas() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      {
        'entrenador_id': 1,
        'nombre_rutina': 'Rutina fuerza A',
        'descripcion': 'Piernas y glúteos intensos'
      },
      {
        'entrenador_id': 2,
        'nombre_rutina': 'Cardio Básico',
        'descripcion': 'Ejercicios para quemar grasa'
      },
    ];
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 54.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            'Gestionar Rutinas',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.textController',
                              Duration(milliseconds: 2000),
                              () => safeSetState(() {}),
                            ),
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Buscar rutinas...',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 0.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30.0,
                            borderWidth: 1.0,
                            buttonSize: 44.0,
                            icon: Icon(
                              Icons.search_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Opciones',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 170.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 12.0, 12.0),
                          child: InkWell(
                            onTap: () {
                              _mostrarCrearRutinaDialog(context);
                            },
                            child: Container(
                              width: 160.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x34090F13),
                                    offset: Offset(0.0, 2.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).primary,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network('').image,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 3.0, 0.0),
                                        child: Icon(
                                          Icons.featured_play_list,
                                          color: FlutterFlowTheme.of(context).alternate,
                                          size: 50.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 12.0),
                                      child: Text(
                                        'Crear Rutina',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context).alternate,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .fontStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Rutinas',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 44.0),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: obtenerRutinasEntrenador(),
                      //future:  obtenerRutinasSimuladas(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error al cargar rutinas'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No hay rutinas disponibles'));
                        } else {
                          final rutinas = snapshot.data!;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: rutinas.length,
                            itemBuilder: (context, index) {
                              final rutina = rutinas[index];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 8.0),
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x32000000),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 36.0,
                                          height: 36.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                          child: Align(
                                            alignment: AlignmentDirectional(0.0, 0.0),
                                            child: FaIcon(
                                              FontAwesomeIcons.solidListAlt,
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  rutina['nombre_rutina'] ?? 'Sin nombre',
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  rutina['descripcion'] ?? 'Sin descripción',
                                                  style: FlutterFlowTheme.of(context).labelMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
