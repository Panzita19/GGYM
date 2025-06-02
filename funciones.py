# funciones.py
import sqlite3
import os

# --------------------------------------------
# 1. Conexión a la base de datos
# --------------------------------------------
def conectar_db():
    """Conecta a la base de datos SQLite y activa las claves foráneas"""
    db_path = "IS.db"

    if not os.path.exists(db_path):
        print(f"ADVERTENCIA: Archivo de base de datos '{db_path}' no encontrado al intentar conectar.")
        return None
    try:
        conexion = sqlite3.connect(db_path)
        conexion.execute("PRAGMA foreign_keys = ON;")  # Activar integridad referencial
        # Establecer row_factory por defecto para esta conexión
        conexion.row_factory = sqlite3.Row # Esto es crucial para obtener diccionarios
        return conexion
    except sqlite3.Error as error:
        print(f"Error de conexión: {error}")
        return None

# --------------------------------------------
# 2. Funciones para la tabla USUARIOS
# --------------------------------------------
def insertar_usuario(nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion):
    """Inserta un nuevo usuario en la tabla Usuarios.
    Los campos Rol y FechaRegistro tienen valores por defecto en la DB."""
    conexion = conectar_db()
    if not conexion:
        return None

    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO Usuarios
            (NombreCompleto, Cedula, Correo, Telefono, FechaNacimiento, Direccion)
            VALUES (?, ?, ?, ?, ?, ?)""",
            (nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion)
        )
        usuario_id = cursor.lastrowid
        conexion.commit()
        print(f"Usuario registrado (ID: {usuario_id})")
        return usuario_id
    except sqlite3.Error as e:
        print(f"Error al insertar usuario: {e}")
        return None
    finally:
        if conexion:
            conexion.close()

def eliminar_usuario(usuario_id):
    """Elimina un usuario por su ID."""
    conexion = conectar_db()
    if not conexion:
        return False
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM Usuarios WHERE UsuarioID = ?", (usuario_id,))
        filas_afectadas = cursor.rowcount
        conexion.commit()
        if filas_afectadas > 0:
            print(f"Usuario {usuario_id} eliminado correctamente.")
            return True
        else:
            print(f"No se encontró el usuario {usuario_id}.")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar usuario: {e}")
        return False
    finally:
        if conexion:
            conexion.close()

def listar_usuarios():
    """Obtiene todos los usuarios con sus datos específicos"""
    conexion = conectar_db()
    if not conexion:
        return []

    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT UsuarioID, NombreCompleto, Cedula, Rol, Correo, Telefono, FechaNacimiento, Direccion, FechaRegistro
            FROM Usuarios
            ORDER BY NombreCompleto
        """)
        return [dict(row) for row in cursor.fetchall()]
    except sqlite3.Error as e:
        print(f"Error al consultar usuarios: {e}")
        return []
    finally:
        conexion.close()

def total_usuarios():
    """Devuelve el conteo total de usuarios"""
    conexion = conectar_db()
    if not conexion:
        return 0

    try:
        cursor = conexion.cursor()
        cursor.execute("SELECT COUNT(*) FROM Usuarios")
        return cursor.fetchone()[0]
    except sqlite3.Error as e:
        print(f"Error al contar usuarios: {e}")
        return 0
    finally:
        if conexion:
            conexion.close()

# --------------------------------------------
# 3. Funciones para la tabla ENTRENADORES
# --------------------------------------------
def insertar_entrenador(nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion, especialidad, certificacion=None):
    """Inserta un nuevo entrenador en la tabla Entrenadores."""
    conexion = conectar_db()
    if not conexion:
        return None

    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO Entrenadores
            (NombreCompleto, Cedula, Correo, Telefono, FechaNacimiento, Direccion, Especialidad, Certificacion)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
            (nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion, especialidad, certificacion)
        )
        entrenador_id = cursor.lastrowid
        conexion.commit()
        print(f"Entrenador registrado (ID: {entrenador_id})")
        return entrenador_id
    except sqlite3.Error as e:
        print(f"Error al insertar entrenador: {e}")
        return None
    finally:
        if conexion:
            conexion.close()

def eliminar_entrenador(entrenador_id):
    """Elimina un entrenador por su ID."""
    conexion = conectar_db()
    if not conexion:
        return False
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM Entrenadores WHERE EntrenadorID = ?", (entrenador_id,))
        filas_afectadas = cursor.rowcount
        conexion.commit()
        if filas_afectadas > 0:
            print(f"Entrenador {entrenador_id} eliminado correctamente.")
            return True
        else:
            print(f"No se encontró el entrenador {entrenador_id}.")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar entrenador: {e}")
        return False
    finally:
        if conexion:
            conexion.close()

def listar_entrenadores():
    """Obtiene todos los entrenadores con sus datos específicos"""
    conexion = conectar_db()
    if not conexion:
        return []

    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT EntrenadorID, NombreCompleto, Cedula, Rol, Correo, Telefono, FechaNacimiento, Direccion, FechaRegistro, Especialidad, Certificacion
            FROM Entrenadores
            ORDER BY NombreCompleto
        """)
        return [dict(row) for row in cursor.fetchall()]
    except sqlite3.Error as e:
        print(f"Error al consultar entrenadores: {e}")
        return []
    finally:
        conexion.close()

# --------------------------------------------
# 4. Funciones para la tabla SUPERVISORES
# --------------------------------------------
def insertar_supervisor(nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion):
    """Inserta un nuevo supervisor en la tabla Supervisores."""
    conexion = conectar_db()
    if not conexion:
        return None

    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO Supervisores
            (NombreCompleto, Cedula, Correo, Telefono, FechaNacimiento, Direccion)
            VALUES (?, ?, ?, ?, ?, ?)""",
            (nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion)
        )
        supervisor_id = cursor.lastrowid
        conexion.commit()
        print(f"Supervisor registrado (ID: {supervisor_id})")
        return supervisor_id
    except sqlite3.Error as e:
        print(f"Error al insertar supervisor: {e}")
        return None
    finally:
        if conexion:
            conexion.close()

def eliminar_supervisor(supervisor_id):
    """Elimina un supervisor por su ID."""
    conexion = conectar_db()
    if not conexion:
        return False
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM Supervisores WHERE SupervisorID = ?", (supervisor_id,))
        filas_afectadas = cursor.rowcount
        conexion.commit()
        if filas_afectadas > 0:
            print(f"No se encontró el supervisor {supervisor_id}.")
            return True
        else:
            print(f"No se encontró el supervisor {supervisor_id}.")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar supervisor: {e}")
        return False
    finally:
        if conexion:
            conexion.close()

def listar_supervisores():
    """Obtiene todos los supervisores con sus datos específicos"""
    conexion = conectar_db()
    if not conexion:
        return []

    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT SupervisorID, NombreCompleto, Cedula, Rol, Correo, Telefono, FechaNacimiento, Direccion, FechaRegistro
            FROM Supervisores
            ORDER BY NombreCompleto
        """)
        return [dict(row) for row in cursor.fetchall()]
    except sqlite3.Error as e:
        print(f"Error al consultar supervisores: {e}")
        return []
    finally:
        conexion.close()

# --------------------------------------------
# 5. Funciones para la tabla RUTINAS
# --------------------------------------------
def insertar_rutina(entrenador_id, nombre_rutina, descripcion=None):
    """Inserta una nueva rutina asociada a un entrenador."""
    conexion = conectar_db()
    if not conexion:
        return None

    try:
        cursor = conexion.cursor()
        # Verificar si el EntrenadorID existe antes de insertar la rutina
        cursor.execute("SELECT 1 FROM Entrenadores WHERE EntrenadorID = ?", (entrenador_id,))
        if cursor.fetchone() is None:
            print(f"Error: El EntrenadorID {entrenador_id} no existe.")
            return None

        cursor.execute(
            """INSERT INTO rutinas
            (EntrenadorID, NombreRutina, Descripcion)
            VALUES (?, ?, ?)""",
            (entrenador_id, nombre_rutina, descripcion)
        )
        rutina_id = cursor.lastrowid
        conexion.commit()
        print(f"Rutina '{nombre_rutina}' registrada (ID: {rutina_id}) para el entrenador {entrenador_id}")
        return rutina_id
    except sqlite3.Error as e:
        print(f"Error al insertar rutina: {e}")
        return None
    finally:
        if conexion:
            conexion.close()

def eliminar_rutina(rutina_id):
    """Elimina una rutina por su ID."""
    conexion = conectar_db()
    if not conexion:
        return False
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM rutinas WHERE RutinaID = ?", (rutina_id,))
        filas_afectadas = cursor.rowcount
        conexion.commit()
        if filas_afectadas > 0:
            print(f"Rutina {rutina_id} eliminada correctamente.")
            return True
        else:
            print(f"No se encontró la rutina {rutina_id}.")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar rutina: {e}")
        return False
    finally:
        if conexion:
            conexion.close()

# --------------------------------------------
# 6. Funciones para la tabla PAGOS
# --------------------------------------------
def insertar_pago(usuario_id, supervisor_id, monto, estado='Pendiente', fecha_pago=None):
    """Registra un nuevo pago."""
    conexion = conectar_db()
    if not conexion:
        return None

    try:
        cursor = conexion.cursor()
        # Verificar que UsuarioID y SupervisorID existan
        cursor.execute("SELECT 1 FROM Usuarios WHERE UsuarioID = ?", (usuario_id,))
        if cursor.fetchone() is None:
            print(f"Error: El UsuarioID {usuario_id} no existe.")
            return None

        cursor.execute("SELECT 1 FROM Supervisores WHERE SupervisorID = ?", (supervisor_id,))
        if cursor.fetchone() is None:
            print(f"Error: El SupervisorID {supervisor_id} no existe.")
            return None

        cursor.execute(
            """INSERT INTO pagos
            (UsuarioID, SupervisorID, Monto, Estado, FechaPago)
            VALUES (?, ?, ?, ?, ?)""",
            (usuario_id, supervisor_id, monto, estado, fecha_pago)
        )
        pago_id = cursor.lastrowid
        conexion.commit()
        print(f"Pago registrado (ID: {pago_id}) para Usuario {usuario_id} por Supervisor {supervisor_id}")
        return pago_id
    except sqlite3.Error as e:
        print(f"Error al insertar pago: {e}")
        return None
    finally:
        if conexion:
            conexion.close()

def eliminar_pago(pago_id):
    """Elimina un pago por su ID."""
    conexion = conectar_db()
    if not conexion:
        return False
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM pagos WHERE PagoID = ?", (pago_id,))
        filas_afectadas = cursor.rowcount
        conexion.commit()
        if filas_afectadas > 0:
            print(f"Pago {pago_id} eliminado correctamente.")
            return True
        else:
            print(f"No se encontró el pago {pago_id}.")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar pago: {e}")
        return False
    finally:
        if conexion:
            conexion.close()

# --------------------------------------------
# 7. Funciones para la tabla PLANES
# --------------------------------------------
def insertar_plan(duracion, monto, descripcion=None, beneficios=None):
    conexion = conectar_db()
    if not conexion: return None
    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO planes (duracion, monto, descripcion, beneficios)
            VALUES (?, ?, ?, ?)""",
            (duracion, monto, descripcion, beneficios)
        )
        plan_id = cursor.lastrowid
        conexion.commit()
        print(f"Plan registrado (ID: {plan_id})")
        return plan_id
    except sqlite3.Error as e:
        print(f"Error al insertar plan: {e}")
        return None
    finally:
        if conexion: conexion.close()

def listar_planes():
    conexion = conectar_db()
    if not conexion: return []
    try:
        cursor = conexion.cursor()
        cursor.execute("SELECT idPlanes, duracion, monto, descripcion, beneficios FROM planes ORDER BY idPlanes")
        return [dict(row) for row in cursor.fetchall()]
    except sqlite3.Error as e:
        print(f"Error al listar planes: {e}")
        return []
    finally:
        if conexion: conexion.close()

# --------------------------------------------
# 8. Funciones para listar TODOS los perfiles (usuarios, entrenadores, supervisores)
# --------------------------------------------
def listar_todos_los_perfiles():
    """
    Obtiene todos los perfiles (usuarios, entrenadores, supervisores)
    y devuelve solo los campos comunes.
    """
    conexion = conectar_db()
    if not conexion:
        return []

    try:
        cursor = conexion.cursor()
        cursor.execute("""
            -- Consulta para Usuarios
            SELECT
                NombreCompleto,
                Cedula,
                Rol,
                Correo,
                Telefono,
                FechaNacimiento,
                Direccion,
                FechaRegistro,
                NULL AS Especialidad,
                NULL AS Certificacion
            FROM Usuarios

            UNION ALL

            -- Consulta para Entrenadores
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

            UNION ALL

            -- Consulta para Supervisores
            SELECT
                NombreCompleto,
                Cedula,
                Rol,
                Correo,
                Telefono,
                FechaNacimiento,
                Direccion,
                FechaRegistro,
                NULL AS Especialidad,
                NULL AS Certificacion
            FROM Supervisores
            ORDER BY Rol, NombreCompleto;
        """)

        results = [dict(row) for row in cursor.fetchall()]

        perfiles_reducidos = []
        for perfil in results:
            perfiles_reducidos.append({
                'NombreCompleto': perfil['NombreCompleto'],
                'Cedula': perfil['Cedula'],
                'Rol': perfil['Rol'],
                'Correo': perfil['Correo'],
                'Telefono': perfil['Telefono'],
                'FechaNacimiento': perfil['FechaNacimiento'],
                'Direccion': perfil['Direccion'],
                'FechaRegistro': perfil['FechaRegistro'],
            })

        return perfiles_reducidos

    except sqlite3.Error as e:
        print(f"Error al listar todos los perfiles: {e}")
        return []
    finally:
        if conexion:
            conexion.close()