import os
from flask import Flask, jsonify, request
from flask_cors import CORS
import sqlite3

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})  # Permitir cualquier origen temporalmente

# Importa las funciones actualizadas desde tu archivo funciones.py
from funciones import (
    conectar_db,
    insertar_usuario, eliminar_usuario, listar_usuarios, total_usuarios,
    insertar_entrenador, eliminar_entrenador, listar_entrenadores,
    insertar_supervisor, eliminar_supervisor, listar_supervisores,
    insertar_rutina, eliminar_rutina,
    insertar_pago, eliminar_pago,
    insertar_plan, listar_planes,
    listar_todos_los_perfiles # <-- ¡IMPORTA LA FUNCIÓN ACTUALIZADA AQUÍ!
)

DATABASE_FILE = "IS.db"
SCHEMA_FILE = "IS.sql"

def inicializar_base_de_datos():
    """
    Inicializa la base de datos eliminando el archivo existente (si lo hay)
    y ejecutando el script SQL para crear el esquema.
    """
    """
    if os.path.exists(DATABASE_FILE):
        try:
            os.remove(DATABASE_FILE)
            print(f"Archivo '{DATABASE_FILE}' existente eliminado para inicialización.")
        except PermissionError:
            print(f"Error: No se pudo eliminar '{DATABASE_FILE}'. Está siendo usado por otro proceso. Por favor, ciérralo y reintenta.")
            return False
    """
    conexion = None
    try:
        conexion = sqlite3.connect(DATABASE_FILE)
        cursor = conexion.cursor()

        with open(SCHEMA_FILE, 'r', encoding='cp1252') as f:
            sql_script = f.read()

        cursor.executescript(sql_script)
        conexion.commit()
        print(f"Base de datos '{DATABASE_FILE}' inicializada con el esquema de '{SCHEMA_FILE}'.")
        return True
    except sqlite3.Error as e:
        print(f"Error de SQLite al inicializar la base de datos: {e}")
        return False
    except FileNotFoundError:
        print(f"Error: El archivo de esquema '{SCHEMA_FILE}' no se encontró. Asegúrate de que 'IS.sql' esté en el mismo directorio.")
        return False
    finally:
        if conexion:
            conexion.close()

# --------------------------------------------------------------------
# Endpoints para USUARIOS
# --------------------------------------------------------------------
@app.route('/usuarios', methods=['POST'])
def crear_usuario_api():
    try:
        data = request.json
        nombre_completo = data.get('nombre_completo')
        cedula = data.get('cedula') # Nuevo campo
        correo = data.get('correo')
        telefono = data.get('telefono')
        fecha_nacimiento = data.get('fecha_nacimiento')
        direccion = data.get('direccion')

        if not all([nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion]):
            return jsonify({'error': 'Faltan datos obligatorios para el usuario.'}), 400

        usuario_id = insertar_usuario(nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion)
        if usuario_id:
            return jsonify({'message': f'Usuario con ID {usuario_id} insertado correctamente.', 'usuario_id': usuario_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar el usuario. Revisa los logs del servidor para más detalles.'}), 500
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /usuarios (POST): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/usuarios/<int:usuario_id>', methods=['DELETE'])
def eliminar_usuario_api(usuario_id):
    try:
        if eliminar_usuario(usuario_id):
            return jsonify({'message': f'Usuario {usuario_id} eliminado correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró el usuario {usuario_id} o no se pudo eliminar.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /usuarios/<id> (DELETE): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/usuarios', methods=['GET'])
def listar_usuarios_api():
    try:
        usuarios = listar_usuarios()
        if usuarios:
            return jsonify(usuarios), 200
        else:
            return jsonify({'message': 'No se encontraron usuarios.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /usuarios (GET): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/usuarios/total', methods=['GET'])
def total_usuarios_api():
    try:
        total = total_usuarios()
        return jsonify({'total_usuarios': total}), 200
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /usuarios/total (GET): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/solo_usuarios', methods=['GET'])
def listar_usuarios_detalle():
    """
    Endpoint que retorna todos los usuarios (no entrenadores ni supervisores),
    con todos sus campos relevantes.
    """
    try:
        conexion = conectar_db()
        if not conexion:
            return jsonify({'error': 'No se pudo conectar a la base de datos'}), 500

        cursor = conexion.cursor()
        cursor.execute("""
            SELECT
                NombreCompleto,
                Cedula,
                Rol,
                Correo,
                Telefono,
                FechaNacimiento,
                Direccion,
                FechaRegistro
            FROM Usuarios
            ORDER BY NombreCompleto;
        """)

        usuarios = [
            {
                'nombre': fila['NombreCompleto'],
                'cedula': fila['Cedula'],
                'rol': fila['Rol'],
                'correo': fila['Correo'],
                'telefono': fila['Telefono'],
                'fechaNacimiento': fila['FechaNacimiento'],
                'direccion': fila['Direccion'],
                'fechaRegistro': fila['FechaRegistro']
            }
            for fila in cursor.fetchall()
            if fila['NombreCompleto'] and fila['Correo']
        ]

        if usuarios:
            return jsonify(usuarios), 200
        else:
            return jsonify({'message': 'No se encontraron usuarios.'}), 404

    except Exception as e:
        print(f"Error en /solo_usuarios: {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
    finally:
        if conexion:
            conexion.close()

# --------------------------------------------------------------------
# Endpoints para ENTRENADORES
# --------------------------------------------------------------------
@app.route('/entrenadores', methods=['POST'])
def crear_entrenador_api():
    try:
        data = request.json
        nombre_completo = data.get('nombre_completo')
        cedula = data.get('cedula')
        correo = data.get('correo')
        telefono = data.get('telefono')
        fecha_nacimiento = data.get('fecha_nacimiento')
        direccion = data.get('direccion')
        especialidad = data.get('especialidad')
        certificacion = data.get('certificacion')

        if not all([nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion]):
            return jsonify({'error': 'Faltan datos obligatorios para el entrenador.'}), 400

        entrenador_id = insertar_entrenador(nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion, especialidad, certificacion)
        if entrenador_id:
            return jsonify({'message': f'Entrenador con ID {entrenador_id} insertado correctamente.', 'entrenador_id': entrenador_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar el entrenador. Revisa los logs del servidor para más detalles.'}), 500
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /entrenadores (POST): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/entrenadores/<int:entrenador_id>', methods=['DELETE'])
def eliminar_entrenador_api(entrenador_id):
    try:
        if eliminar_entrenador(entrenador_id):
            return jsonify({'message': f'Entrenador {entrenador_id} eliminado correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró el entrenador {entrenador_id} o no se pudo eliminar.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /entrenadores/<id> (DELETE): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/entrenadores', methods=['GET'])
def listar_entrenadores_api():
    try:
        entrenadores = listar_entrenadores()
        if entrenadores:
            return jsonify(entrenadores), 200
        else:
            return jsonify({'message': 'No se encontraron entrenadores.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /entrenadores (GET): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/solo_entrenadores', methods=['GET'])
def listar_entrenadores_detalle():
    """
    Endpoint que retorna todos los entrenadores con todos sus campos relevantes.
    """
    try:
        conexion = conectar_db()
        if not conexion:
            return jsonify({'error': 'No se pudo conectar a la base de datos'}), 500

        cursor = conexion.cursor()
        cursor.execute("""
            SELECT
                NombreCompleto,
                Cedula,
                Rol,
                Correo,
                Telefono,
                FechaNacimiento,
                Direccion,
                FechaRegistro,
                Especialidad,
                Certificacion
            FROM Entrenadores
            ORDER BY NombreCompleto;
        """)

        entrenadores = [
            {
                'nombre': fila['NombreCompleto'],
                'cedula': fila['Cedula'],
                'rol': fila['Rol'],
                'correo': fila['Correo'],
                'telefono': fila['Telefono'],
                'fechaNacimiento': fila['FechaNacimiento'],
                'direccion': fila['Direccion'],
                'fechaRegistro': fila['FechaRegistro'],
                'especialidad': fila['Especialidad'],
                'certificacion': fila['Certificacion']
            }
            for fila in cursor.fetchall()
            if fila['NombreCompleto'] and fila['Correo']
        ]

        if entrenadores:
            return jsonify(entrenadores), 200
        else:
            return jsonify({'message': 'No se encontraron entrenadores.'}), 404

    except Exception as e:
        print(f"Error en /solo_entrenadores: {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
    finally:
        if conexion:
            conexion.close()

# --------------------------------------------------------------------
# Endpoints para SUPERVISORES
# --------------------------------------------------------------------
@app.route('/supervisores', methods=['POST'])
def crear_supervisor_api():
    try:
        data = request.json
        nombre_completo = data.get('nombre_completo')
        cedula = data.get('cedula') # Nuevo campo
        correo = data.get('correo')
        telefono = data.get('telefono')
        fecha_nacimiento = data.get('fecha_nacimiento')
        direccion = data.get('direccion')

        if not all([nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion]):
            return jsonify({'error': 'Faltan datos obligatorios para el supervisor.'}), 400

        supervisor_id = insertar_supervisor(nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion)
        if supervisor_id:
            return jsonify({'message': f'Supervisor con ID {supervisor_id} insertado correctamente.', 'supervisor_id': supervisor_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar el supervisor. Revisa los logs del servidor para más detalles.'}), 500
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /supervisores (POST): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/supervisores/<int:supervisor_id>', methods=['DELETE'])
def eliminar_supervisor_api(supervisor_id):
    try:
        if eliminar_supervisor(supervisor_id):
            return jsonify({'message': f'Supervisor {supervisor_id} eliminado correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró el supervisor {supervisor_id} o no se pudo eliminar.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /supervisores/<id> (DELETE): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/supervisores', methods=['GET'])
def listar_supervisores_api():
    try:
        supervisores = listar_supervisores()
        if supervisores:
            return jsonify(supervisores), 200
        else:
            return jsonify({'message': 'No se encontraron supervisores.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /supervisores (GET): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

# --------------------------------------------------------------------
# Endpoints para RUTINAS
# --------------------------------------------------------------------
@app.route('/rutinas', methods=['POST'])
def crear_rutina_api():
    try:
        data = request.json
        entrenador_id = data.get('entrenador_id')
        nombre_rutina = data.get('nombre_rutina')
        descripcion = data.get('descripcion')

        if not all([entrenador_id, nombre_rutina]):
            return jsonify({'error': 'Faltan datos obligatorios para la rutina.'}), 400

        rutina_id = insertar_rutina(entrenador_id, nombre_rutina, descripcion)
        if rutina_id:
            return jsonify({'message': f'Rutina con ID {rutina_id} insertada correctamente.', 'rutina_id': rutina_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar la rutina. Asegúrate de que el EntrenadorID exista.'}), 500
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /rutinas (POST): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/rutinas_entrenador', methods=['GET'])
def obtener_rutinas_por_entrenador():
    """
    Devuelve todas las rutinas asociadas al Entrenador con ID 1.
    """
    entrenador_id = 1  # ID fijo, puedes modificarlo si luego lo pasas como parámetro

    conexion = conectar_db()
    if not conexion:
        return jsonify({'error': 'No se pudo conectar a la base de datos'}), 500

    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT RutinaID, EntrenadorID, NombreRutina, Descripcion
            FROM rutinas
            WHERE EntrenadorID = ?
            ORDER BY RutinaID DESC;
        """, (entrenador_id,))

        rutinas = [
            {
                'rutina_id': fila['RutinaID'],
                'entrenador_id': fila['EntrenadorID'],
                'nombre_rutina': fila['NombreRutina'],
                'descripcion': fila['Descripcion']
            }
            for fila in cursor.fetchall()
        ]

        if rutinas:
            return jsonify(rutinas), 200
        else:
            return jsonify({'message': 'No se encontraron rutinas para el entrenador.'}), 404

    except Exception as e:
        print(f"API: Error al obtener rutinas del entrenador: {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500
    finally:
        if conexion:
            conexion.close()

@app.route('/rutinas/<int:rutina_id>', methods=['DELETE'])
def eliminar_rutina_api(rutina_id):
    try:
        if eliminar_rutina(rutina_id):
            return jsonify({'message': f'Rutina {rutina_id} eliminada correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró la rutina {rutina_id} o no se pudo eliminar.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /rutinas/<id> (DELETE): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

# --------------------------------------------------------------------
# Endpoints para PAGOS
# --------------------------------------------------------------------
@app.route('/pagos', methods=['POST'])
def crear_pago_api():
    try:
        data = request.json
        usuario_id = data.get('usuario_id')
        supervisor_id = data.get('supervisor_id')
        monto = data.get('monto')
        estado = data.get('estado')
        fecha_pago = data.get('fecha_pago')

        if not all([usuario_id, supervisor_id, monto]):
            return jsonify({'error': 'Faltan datos obligatorios para el pago.'}), 400

        pago_id = insertar_pago(usuario_id, supervisor_id, monto, estado, fecha_pago)
        if pago_id:
            return jsonify({'message': f'Pago con ID {pago_id} registrado correctamente.', 'pago_id': pago_id}), 201
        else:
            return jsonify({'error': 'Fallo al registrar el pago. Asegúrate de que UsuarioID y SupervisorID existan.'}), 500
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /pagos (POST): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/pagos/<int:pago_id>', methods=['DELETE'])
def eliminar_pago_api(pago_id):
    """
    Endpoint para eliminar un pago por su ID.
    """
    try:
        if eliminar_pago(pago_id):
            return jsonify({'message': f'Pago {pago_id} eliminado correctamente.'}), 200
        else:
            return jsonify({'error': f'No se encontró el pago {pago_id} o no se pudo eliminar.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /pagos/<id> (DELETE): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

# --------------------------------------------------------------------
# Endpoints para PLANES
# --------------------------------------------------------------------
@app.route('/planes', methods=['POST'])
def crear_plan_api():
    try:
        data = request.json
        duracion = data.get('duracion')
        monto = data.get('monto')
        descripcion = data.get('descripcion')
        beneficios = data.get('beneficios')

        if not all([duracion, monto]):
            return jsonify({'error': 'Faltan datos obligatorios para el plan.'}), 400

        plan_id = insertar_plan(duracion, monto, descripcion, beneficios)
        if plan_id:
            return jsonify({'message': f'Plan con ID {plan_id} insertado correctamente.', 'plan_id': plan_id}), 201
        else:
            return jsonify({'error': 'Fallo al insertar el plan. Revisa los logs del servidor para más detalles.'}), 500
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /planes (POST): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

@app.route('/planes', methods=['GET'])
def listar_planes_api():
    """Endpoint para listar todos los planes."""
    try:
        planes = listar_planes()
        if planes:
            return jsonify(planes), 200
        else:
            return jsonify({'message': 'No se encontraron planes.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /planes (GET): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

# --------------------------------------------------------------------
# Endpoints para TODOS LOS PERFILES
# --------------------------------------------------------------------
@app.route('/todos_los_perfiles', methods=['GET'])
def listar_todos_los_perfiles_api():
    """
    Endpoint para listar todos los perfiles (usuarios, entrenadores, supervisores)
    con un rol unificado, en el orden deseado y sin campos null si no aplican.
    """
    try:
        perfiles = listar_todos_los_perfiles()
        if perfiles:
            return jsonify(perfiles), 200
        else:
            return jsonify({'message': 'No se encontraron perfiles de ningún tipo.'}), 404
    except Exception as e:
        print(f"API: Ocurrió un error inesperado en /todos_los_perfiles (GET): {e}")
        return jsonify({'error': f'Ocurrió un error inesperado: {str(e)}'}), 500

if __name__ == '__main__':
    print("Iniciando inicialización de la base de datos...")
    if inicializar_base_de_datos():
        print("Base de datos lista. Iniciando servidor Flask...")
        app.run(debug=True, port=5000)
    else:
        print("Fallo la inicialización de la base de datos. No se pudo iniciar el servidor Flask.")