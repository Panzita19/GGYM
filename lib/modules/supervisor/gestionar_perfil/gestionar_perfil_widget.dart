import 'package:ggym/shared/flutter_flow/flutter_flow_icon_button.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_theme.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_util.dart';
import 'package:ggym/shared/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:ggym/shared/flutter_flow/random_data_util.dart' as random_data;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'gestionar_perfil_model.dart';
export 'gestionar_perfil_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GestionarPerfilWidget extends StatefulWidget {
  const GestionarPerfilWidget({super.key});

  static String routeName = 'gestionarPerfil';
  static String routePath = '/gestionarPerfil';

  @override
  State<GestionarPerfilWidget> createState() => _GestionarPerfilWidgetState();
}

class _GestionarPerfilWidgetState extends State<GestionarPerfilWidget> {
  late GestionarPerfilModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String serverIP = 'http://127.0.0.1:5000'; // o http://192.168.X.X:5000

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GestionarPerfilModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }


  Future<bool> enviarSupervisorAlServidor({
    required String nombreCompleto,
    required String cedula,
    required String correo,
    required String telefono,
    required String fechaNacimiento,
    required String direccion,
  }) async {
    final url = Uri.parse('$serverIP/supervisores');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre_completo': nombreCompleto,
          'cedula': cedula,
          'correo': correo,
          'telefono': telefono,
          'fecha_nacimiento': fechaNacimiento,
          'direccion': direccion,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error al enviar supervisor: $e');
      return false;
    }
  }

  Future<bool> enviarEntrenadorAlServidor({
    required String nombreCompleto,
    required String cedula,
    required String correo,
    required String telefono,
    required String fechaNacimiento,
    required String direccion,
    required String especialidad,
    required String certificacion,
  }) async {
    final url = Uri.parse('$serverIP/entrenadores');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre_completo': nombreCompleto,
          'cedula': cedula,
          'correo': correo,
          'telefono': telefono,
          'fecha_nacimiento': fechaNacimiento,
          'direccion': direccion,
          'especialidad': especialidad,
          'certificacion': certificacion,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error al enviar entrenador: $e');
      return false;
    }
  }

  Future<bool> enviarUsuarioAlServidor({
    required String nombreCompleto,
    required String cedula,
    required String correo,
    required String telefono,
    required String fechaNacimiento, // formato: 'YYYY-MM-DD'
    required String direccion,
  }) async {
    final url = Uri.parse('$serverIP/usuarios'); // Asegúrate de definir correctamente $serverIP

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre_completo': nombreCompleto,
          'cedula': cedula,
          'correo': correo,
          'telefono': telefono,
          'fecha_nacimiento': fechaNacimiento,
          'direccion': direccion,
        }),
      );

      if (response.statusCode == 201) {
        print('✅ Usuario creado correctamente.');
        return true;
      } else {
        print('❌ Error al crear usuario: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error en enviarUsuarioAlServidor: $e');
      return false;
    }
  }

  Future<List<Map<String, String>>> obtenerSoloUsuarios() async {
    final url = Uri.parse('$serverIP/solo_usuarios');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Convertimos cada elemento del JSON en un Map<String, String> con todos los campos esperados
        return data.map<Map<String, String>>((usuario) {
          return {
            'nombre': usuario['nombre']?.toString() ?? '',
            'cedula': usuario['cedula']?.toString() ?? '',
            'rol': usuario['rol']?.toString() ?? '',
            'correo': usuario['correo']?.toString() ?? '',
            'telefono': usuario['telefono']?.toString() ?? '',
            'fechaNacimiento': usuario['fechaNacimiento']?.toString() ?? '',
            'direccion': usuario['direccion']?.toString() ?? '',
            'fechaRegistro': usuario['fechaRegistro']?.toString() ?? '',
          };
        }).toList();
      } else if (response.statusCode == 404) {
        print('No se encontraron usuarios.');
        return [];
      } else {
        throw Exception('Error al obtener usuarios: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en obtenerSoloUsuarios(): $e');
      return [];
    }
  }

  Future<List<Map<String, String>>> obtenerSoloEntrenadores() async {
    final url = Uri.parse('$serverIP/solo_entrenadores');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Convertimos cada elemento en Map<String, String>
        return data.map<Map<String, String>>((entrenador) {
          return {
            'nombre': entrenador['nombre']?.toString() ?? '',
            'cedula': entrenador['cedula']?.toString() ?? '',
            'rol': entrenador['rol']?.toString() ?? '',
            'correo': entrenador['correo']?.toString() ?? '',
            'telefono': entrenador['telefono']?.toString() ?? '',
            'fechaNacimiento': entrenador['fechaNacimiento']?.toString() ?? '',
            'direccion': entrenador['direccion']?.toString() ?? '',
            'fechaRegistro': entrenador['fechaRegistro']?.toString() ?? '',
            'especialidad': entrenador['Especialidad']?.toString() ?? '',
            'certificacion': entrenador['Certificacion']?.toString() ?? '',
          };
        }).toList();
      } else if (response.statusCode == 404) {
        print('No se encontraron entrenadores.');
        return [];
      } else {
        throw Exception('Error al obtener entrenadores: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en obtenerSoloEntrenadores(): $e');
      return [];
    }
  }

  Future<List<Map<String, String>>> obtenerUsuariosSimulados() async {
    await Future.delayed(Duration(seconds: 1)); // Simula tiempo de carga
    return [
      {
        'nombre': 'Carlos González',
        'cedula': '12345678',
        'rol': 'Usuario',
        'correo': 'carlos@example.com',
        'telefono': '04141234567',
        'fechaNacimiento': '1990-05-10',
        'direccion': 'Av. Principal, Caracas',
        'fechaRegistro': '2024-01-15',
      },
      {
        'nombre': 'Ana Torres',
        'cedula': '87654321',
        'rol': 'Usuario',
        'correo': 'ana@example.com',
        'telefono': '04142345678',
        'fechaNacimiento': '1992-07-22',
        'direccion': 'Calle Falsa 123, Maracay',
        'fechaRegistro': '2024-02-01',
      },
      {
        'nombre': 'Luis Herrera',
        'cedula': '11223344',
        'rol': 'Usuario',
        'correo': 'luis@example.com',
        'telefono': '04143456789',
        'fechaNacimiento': '1988-03-30',
        'direccion': 'Urb. La Trigaleña, Valencia',
        'fechaRegistro': '2024-03-10',
      },
    ];
  }

  // --- INICIO DE LA FUNCIÓN _mostrarCrearPerfilDialog ---
  Future<void> _mostrarCrearPerfilDialog(BuildContext context) async {
    // Controladores para los campos de texto del formulario del diálogo
    TextEditingController nombreCompletoController = TextEditingController();
    TextEditingController cedulaController = TextEditingController();
    TextEditingController correoController = TextEditingController();
    TextEditingController telefonoController = TextEditingController();
    TextEditingController fechaNacimientoController = TextEditingController();
    TextEditingController direccionController = TextEditingController();
    TextEditingController especialidadController = TextEditingController();
    TextEditingController certificacionController = TextEditingController();

    // Variables para los campos del diálogo
    String? selectedRol; // Para el Dropdown
    DateTime? selectedFechaNacimiento; // Para el DatePicker

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Usamos un StatefulBuilder para manejar el estado del diálogo (Dropdown y campos dinámicos)
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: SingleChildScrollView( // Para que el diálogo sea desplazable si hay muchos campos
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
                          'Crear Nuevo Perfil',
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                      // Campo: Nombre completo
                      TextFormField(
                        controller: nombreCompletoController,
                        decoration: InputDecoration(
                          labelText: 'Nombre Completo',
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

                      // Campo: Cédula
                      TextFormField(
                        controller: cedulaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Cédula',
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

                      // Campo: Rol (DropdownButton)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedRol,
                            hint: Text(
                              'Selecciona un Rol',
                              style: FlutterFlowTheme.of(context).labelMedium,
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
                            isExpanded: true,
                            items: <String>['Usuario', 'Entrenador', 'Supervisor']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() { // Usa el setState del StatefulBuilder para actualizar el diálogo
                                selectedRol = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // Campo: Correo
                      TextFormField(
                        controller: correoController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo',
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

                      // Campo: Teléfono
                      TextFormField(
                        controller: telefonoController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
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

                      // Campo: Fecha de Nacimiento (con DatePicker)
                      TextFormField(
                        controller: fechaNacimientoController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Fecha de Nacimiento',
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
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: dialogContext,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: FlutterFlowTheme.of(context).primary,
                                    onPrimary: Colors.white,
                                    surface: FlutterFlowTheme.of(context).primaryBackground,
                                    onSurface: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: FlutterFlowTheme.of(context).primaryText,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            setState(() { // Usa el setState del StatefulBuilder
                              selectedFechaNacimiento = pickedDate;
                              fechaNacimientoController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                            });
                          }
                        },
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        cursorColor: FlutterFlowTheme.of(context).primary,
                      ),
                      SizedBox(height: 16.0),

                      // Campo: Dirección
                      TextFormField(
                        controller: direccionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Dirección',
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

                      // Campos condicionales para Entrenador
                      if (selectedRol == 'Entrenador') ...[
                        TextFormField(
                          controller: especialidadController,
                          decoration: InputDecoration(
                            labelText: 'Especialidad',
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
                        TextFormField(
                          controller: certificacionController,
                          decoration: InputDecoration(
                            labelText: 'Certificación',
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
                      ],

                      SizedBox(height: 24.0),

                      // Botón para guardar el perfil
                      FFButtonWidget(
                        onPressed: () async {
                          String nombreCompleto = nombreCompletoController.text;
                          String cedula = cedulaController.text;
                          String correo = correoController.text;
                          String telefono = telefonoController.text;
                          String direccion = direccionController.text;
                          String especialidad = especialidadController.text;
                          String certificacion = certificacionController.text;

                          // Validar campos comunes
                          if (nombreCompleto.isEmpty ||
                              cedula.isEmpty ||
                              selectedRol == null ||
                              correo.isEmpty ||
                              telefono.isEmpty ||
                              selectedFechaNacimiento == null ||
                              direccion.isEmpty) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text('Por favor, completa todos los campos obligatorios.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Validar campos específicos del entrenador
                          if (selectedRol == 'Entrenador' &&
                              (especialidad.isEmpty || certificacion.isEmpty)) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text('Por favor, completa la especialidad y certificación del entrenador.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Preparar fecha en formato yyyy-MM-dd
                          final fechaNacimientoFormato = DateFormat('yyyy-MM-dd').format(selectedFechaNacimiento!);

                          // Lógica de envío según el rol
                          bool exito = false;

                          if (selectedRol == 'Usuario') {
                            exito = await enviarUsuarioAlServidor(
                              nombreCompleto: nombreCompleto,
                              cedula: cedula,
                              correo: correo,
                              telefono: telefono,
                              fechaNacimiento: fechaNacimientoFormato,
                              direccion: direccion,
                            );
                          } else if (selectedRol == 'Entrenador') {
                            exito = await enviarEntrenadorAlServidor(
                              nombreCompleto: nombreCompleto,
                              cedula: cedula,
                              correo: correo,
                              telefono: telefono,
                              fechaNacimiento: fechaNacimientoFormato,
                              direccion: direccion,
                              especialidad: especialidad,
                              certificacion: certificacion,
                            );
                          } else if (selectedRol == 'Supervisor') {
                            exito = await enviarSupervisorAlServidor(
                              nombreCompleto: nombreCompleto,
                              cedula: cedula,
                              correo: correo,
                              telefono: telefono,
                              fechaNacimiento: fechaNacimientoFormato,
                              direccion: direccion,
                            );
                          }

                          // Resultado
                          if (exito) {
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Perfil creado exitosamente.')),
                            );
                          } else {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text('Error al crear el perfil.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        text: 'Guardar Perfil',
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
      },
    );

    // Liberar los controladores al cerrar el diálogo
    nombreCompletoController.dispose();
    cedulaController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    fechaNacimientoController.dispose();
    direccionController.dispose();
    especialidadController.dispose();
    certificacionController.dispose();
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
            'Gestionar Perfiles',
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
                              labelText: 'Buscar perfil...',
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
                              _mostrarCrearPerfilDialog(context);
                            },
                            borderRadius: BorderRadius.circular(8.0),
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
                                          Icons.person_add,
                                          color: FlutterFlowTheme.of(context).alternate,
                                          size: 50.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 12.0),
                                      child: Text(
                                        'Crear Perfil',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: GoogleFonts.inter().fontFamily,
                                          fontWeight: FontWeight.w600,
                                          color: FlutterFlowTheme.of(context).alternate,
                                          letterSpacing: 0.0,
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
                      'Usuarios',
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
                    child: FutureBuilder<List<Map<String, String>>>(
                      //future: obtenerUsuariosSimulados(), //USUARIOS SIMULADOS
                      future: obtenerSoloUsuarios(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error al cargar los usuarios'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No hay usuarios registrados'));
                        } else {
                          final usuarios = snapshot.data!;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: usuarios.length,
                            itemBuilder: (context, index) {
                              final usuario = usuarios[index];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 8.0),
                                child: Container(
                                  height: 90.0,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(26.0),
                                          child: Image.network(
                                            'https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png',
                                            width: 36.0,
                                            height: 36.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  usuario['nombre'] ?? 'Sin nombre',
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  usuario['rol'] ?? 'Sin correo',
                                                  style: FlutterFlowTheme.of(context).labelMedium,
                                                ),
                                                Text(
                                                  usuario['correo'] ?? 'Sin nombre',
                                                  style: FlutterFlowTheme.of(context).labelMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                          child: FFButtonWidget(
                                            onPressed: () {
                                              context.pushNamed(
                                                'perfilClienteSup',
                                                queryParameters: {
                                                  'nombre': usuario['nombre']!,
                                                  'cedula': usuario['cedula']!,
                                                  'rol': usuario['rol']!,
                                                  'correo': usuario['correo']!,
                                                  'telefono': usuario['telefono']!,
                                                  'fechaNacimiento': usuario['fechaNacimiento']!,
                                                  'direccion': usuario['direccion']!,
                                                  'fechaRegistro': usuario['fechaRegistro']!,
                                                },
                                              );
                                            },
                                            text: 'Ver',
                                            options: FFButtonOptions(
                                              width: 70.0,
                                              height: 36.0,
                                              color: FlutterFlowTheme.of(context).primary,
                                              textStyle:
                                              FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                fontWeight: FontWeight.bold,
                                                color:
                                                FlutterFlowTheme.of(context).alternate,
                                                fontSize: 14.0,
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
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
                  Padding(
                    padding:
                    EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Entrenadores',
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
                    child: FutureBuilder<List<Map<String, String>>>(
                      future: obtenerSoloEntrenadores(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error al cargar los usuarios'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No hay usuarios registrados'));
                        } else {
                          final usuarios = snapshot.data!;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: usuarios.length,
                            itemBuilder: (context, index) {
                              final usuario = usuarios[index];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 8.0),
                                child: Container(
                                  height: 90.0,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(26.0),
                                          child: Image.network(
                                            'https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png',
                                            width: 36.0,
                                            height: 36.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  usuario['nombre'] ?? 'Sin nombre',
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  usuario['rol'] ?? 'Sin correo',
                                                  style: FlutterFlowTheme.of(context).labelMedium,
                                                ),
                                                Text(
                                                  usuario['correo'] ?? 'Sin nombre',
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
