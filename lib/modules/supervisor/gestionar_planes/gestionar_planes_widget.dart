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
import 'gestionar_planes_model.dart';
export 'gestionar_planes_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class GestionarPlanesWidget extends StatefulWidget {
  const GestionarPlanesWidget({super.key});

  static String routeName = 'gestionarPlanes';
  static String routePath = '/gestionarPlanes';

  @override
  State<GestionarPlanesWidget> createState() => _GestionarPlanesWidgetState();
}

class _GestionarPlanesWidgetState extends State<GestionarPlanesWidget> {
  late GestionarPlanesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String serverIP = 'http://localhost:5000'; // o http://192.168.X.X:5000

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GestionarPlanesModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  Future<void> crearPlan({
    required double monto,
    required String descripcion,
    required String beneficios,
    required String duracion,
  }) async {
    final url = Uri.parse('$serverIP/planes');

    final Map<String, dynamic> planData = {
      'monto': monto,
      'descripcion': descripcion,
      'beneficios': beneficios,
      'duracion': duracion,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(planData),
      );

      if (response.statusCode == 201) {
        print('✅ Plan creado exitosamente');
      } else {
        print('❌ Error al crear el plan: ${response.statusCode}');
        print('Respuesta: ${response.body}');
      }
    } catch (e) {
      print('❌ Excepción en crearPlan(): $e');
    }
  }

  Future<List<Map<String, String>>> obtenerPlanesDesdeServidor() async {
    final url = Uri.parse('$serverIP/planes');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map<Map<String, String>>((plan) {
          return {
            'descripcion': plan['descripcion'] ?? '',
            'beneficios': plan['beneficios'] ?? '',
            'duracion': plan['duracion'] ?? '',
            'precio': plan['monto']?.toStringAsFixed(2) ?? '',
          };
        }).toList();
      } else if (response.statusCode == 404) {
        print('No se encontraron planes.');
        return [];
      } else {
        throw Exception('Error al obtener planes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en obtenerPlanesDesdeServidor(): $e');
      return [];
    }
  }


  Future<List<Map<String, String>>> obtenerPlanesSimulados() async {
    await Future.delayed(Duration(seconds: 1)); // simula carga
    return [
      {
        'precio': '25.00 USD',
        'descripcion': 'Plan Básico',
        'beneficios': 'Acceso general al gimnasio',
        'duracion': '1 mes',
      },
      {
        'precio': '65.00 USD',
        'descripcion': 'Plan Semestral',
        'beneficios': 'Acceso completo + clases dirigidas',
        'duracion': '6 meses',
      },
      {
        'precio': '110.00 USD',
        'descripcion': 'Plan Anual',
        'beneficios': 'Acceso total + entrenamiento personalizado',
        'duracion': '12 meses',
      },
    ];
  }

  // --- INICIO DE LA FUNCIÓN _mostrarCrearPlanDialog ---
  Future<void> _mostrarCrearPlanDialog(BuildContext context) async {
    // Controladores para los campos de texto del formulario del diálogo
    TextEditingController precioController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();
    TextEditingController beneficiosController = TextEditingController();
    TextEditingController duracionController = TextEditingController();

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
                  // Botón de cierre (icono 'X')
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
                  // Título del diálogo
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 20.0),
                    child: Text(
                      'Crear Nuevo Plan',
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: GoogleFonts.interTight().fontFamily,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  // Campo: Precio
                  TextFormField(
                    controller: precioController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Precio',
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

                  // Campo: Descripción del Plan
                  TextFormField(
                    controller: descripcionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Descripción del Plan',
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
                  SizedBox(height: 16.0),

                  // Campo: Beneficios
                  TextFormField(
                    controller: beneficiosController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Beneficios',
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
                  SizedBox(height: 16.0),

                  // Campo: Duración (en meses, por ejemplo)
                  TextFormField(
                    controller: duracionController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Duración (en meses)',
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

                  // Botón para guardar el plan
                  FFButtonWidget(
                    onPressed: () async {
                      // Obtener los valores de los controladores
                      String precio = precioController.text;
                      String descripcion = descripcionController.text;
                      String beneficios = beneficiosController.text;
                      String duracion = duracionController.text;

                      // Validar campos
                      if (precio.isEmpty || descripcion.isEmpty || beneficios.isEmpty || duracion.isEmpty) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, completa todos los campos.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Convertir precio y duración
                      double? precioDouble = double.tryParse(precio);
                      int? duracionInt = int.tryParse(duracion);

                      if (precioDouble == null || duracionInt == null) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, ingresa valores numéricos válidos para Precio y Duración.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Enviar al servidor
                      final url = Uri.parse('$serverIP/planes');
                      final Map<String, dynamic> planData = {
                        'monto': precioDouble,
                        'descripcion': descripcion,
                        'beneficios': beneficios,
                        'duracion': '$duracionInt meses',
                      };

                      try {
                        final response = await http.post(
                          url,
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(planData),
                        );

                        if (response.statusCode == 201) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: Text('✅ Plan creado exitosamente!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                              content: Text('❌ Error al guardar el plan. Código: ${response.statusCode}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('❌ Error de conexión: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      Navigator.pop(dialogContext); // Cierra el diálogo al guardar
                    },
                    text: 'Guardar Plan',
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

    // Liberar los controladores al cerrar el diálogo
    precioController.dispose();
    descripcionController.dispose();
    beneficiosController.dispose();
    duracionController.dispose();
  }
  // --- FIN DE LA FUNCIÓN _mostrarCrearPlanDialog ---

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
            'Gestionar Planes',
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
                              labelText: 'Buscar plan...',
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 12.0, 12.0),
                          child: InkWell( // Envuelve el Container con InkWell para hacerlo clicable
                            onTap: () async {
                              // Llama a la función para mostrar el diálogo de creación de plan
                              await _mostrarCrearPlanDialog(context);
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
                                    offset: Offset(
                                      0.0,
                                      2.0,
                                    ),
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network(
                                            '',
                                          ).image,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 3.0, 0.0),
                                        child: Icon(
                                          Icons.featured_play_list,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          size: 50.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 12.0),
                                      child: Text(
                                        'Crear Plan',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                            FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                          FlutterFlowTheme.of(context)
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
                      'Planes',
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
                  FutureBuilder<List<Map<String, String>>>(
                    //future: obtenerPlanesSimulados(),
                    future: obtenerPlanesDesdeServidor(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error al cargar planes'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No hay planes disponibles'));
                      }

                      final planes = snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: planes.length,
                        itemBuilder: (context, index) {
                          final plan = planes[index];

                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 8.0),
                            child: Container(
                              height: 112.99,
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
                                              plan['descripcion'] ?? '',
                                              style: FlutterFlowTheme.of(context).bodyMedium,
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              'Beneficios: ${plan['beneficios'] ?? ''}',
                                              style: FlutterFlowTheme.of(context).labelMedium,
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              'Duración: ${plan['duracion'] ?? ''} | Precio: ${plan['precio'] ?? ''}',
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
                    },
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