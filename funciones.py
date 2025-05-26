import sqlite3

# --------------------------------------------
# 1. Conexión a la base de datos
# --------------------------------------------
def conectar_db():
    """Conecta a la base de datos y devuelve la conexión."""
    try:
        conexion = sqlite3.connect('IS.sql')
        conexion.execute("PRAGMA foreign_keys = ON;")  # Activar integridad referencial
        return conexion
    except sqlite3.Error as error:
        print(f"Error de conexión: {error}")
        return None

# --------------------------------------------
# 2. Funciones para la tabla PERFILES
# --------------------------------------------
def insertar_perfil(tipo_perfil, nombre_completo, correo, telefono, fecha_nacimiento=None, direccion=None):
    """Inserta un nuevo perfil en la tabla perfiles"""
    conexion = conectar_db()
    if not conexion:
        return None
    
    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO perfiles 
            (TipoPerfil, NombreCompleto, CorreoElectronico, Telefono, FechaNacimiento, Direccion) 
            VALUES (?, ?, ?, ?, ?, ?)""",
            (tipo_perfil, nombre_completo, correo, telefono, fecha_nacimiento, direccion)
        )
        perfil_id = cursor.lastrowid
        conexion.commit()
        print(f"Perfil insertado (ID: {perfil_id})")
        return perfil_id
    except sqlite3.IntegrityError as e:
        print(f"Error: {e} (¿Correo duplicado?)")
        return None
    finally:
        conexion.close()

def eliminar_perfil(perfil_id):
    """Elimina un perfil por su ID"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM perfiles WHERE PerfilID = ?", (perfil_id,))
        conexion.commit()
        if cursor.rowcount > 0:
            print(f"Perfil {perfil_id} eliminado")
            return True
        else:
            print(f"No se encontró el perfil {perfil_id}")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar: {e}")
        return False
    finally:
        conexion.close()

# --------------------------------------------
# 3. Funciones para la tabla USUARIOS
# --------------------------------------------
def insertar_usuario(perfil_id):
    """Inserta un usuario en perfilesUsuarios"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO perfilesUsuarios 
            (UsuarioID) 
            VALUES (?)""",
            (perfil_id)
        )
        conexion.commit()
        print(f"Usuario registrado (ID: {perfil_id})")
        return True
    except sqlite3.Error as e:
        print(f"Error: {e}")
        return False
    finally:
        conexion.close()

def eliminar_usuario(usuario_id):
    """Elimina un usuario por su ID"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM perfilesUsuarios WHERE UsuarioID = ?", (usuario_id,))
        conexion.commit()
        if cursor.rowcount > 0:
            print(f"Usuario {usuario_id} eliminado")
            return True
        else:
            print(f"No se encontró el usuario {usuario_id}")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar: {e}")
        return False
    finally:
        conexion.close()

# --------------------------------------------
# 4. Funciones para la tabla ENTRENADORES
# --------------------------------------------
def insertar_entrenador(perfil_id, especialidad, certificacion=None):
    """Inserta un entrenador en perfilesEntrenadores"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO perfilesEntrenadores 
            (EntrenadorID, Especialidad, Certificacion) 
            VALUES (?, ?, ?)""",
            (perfil_id, especialidad, certificacion)
        )
        conexion.commit()
        print(f"Entrenador registrado (ID: {perfil_id})")
        return True
    except sqlite3.Error as e:
        print(f"Error: {e}")
        return False
    finally:
        conexion.close()

def eliminar_entrenador(entrenador_id):
    """Elimina un entrenador por su ID"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM perfilesEntrenadores WHERE EntrenadorID = ?", (entrenador_id,))
        conexion.commit()
        if cursor.rowcount > 0:
            print(f"Entrenador {entrenador_id} eliminado")
            return True
        else:
            print(f"No se encontró el entrenador {entrenador_id}")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar: {e}")
        return False
    finally:
        conexion.close()

# --------------------------------------------
# 5. Funciones para la tabla SUPERVISORES
# --------------------------------------------
def insertar_supervisor(perfil_id, nivel_acceso=1):
    """Inserta un supervisor en perfilesSupervisores"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO perfilesSupervisores 
            (SupervisorID, NivelAcceso) 
            VALUES (?, ?)""",
            (perfil_id, nivel_acceso)
        )
        conexion.commit()
        print(f"Supervisor registrado (ID: {perfil_id})")
        return True
    except sqlite3.Error as e:
        print(f"Error: {e}")
        return False
    finally:
        conexion.close()

def eliminar_supervisor(supervisor_id):
    """Elimina un supervisor por su ID"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM perfilesSupervisores WHERE SupervisorID = ?", (supervisor_id,))
        conexion.commit()
        if cursor.rowcount > 0:
            print(f"Supervisor {supervisor_id} eliminado")
            return True
        else:
            print(f"No se encontró el supervisor {supervisor_id}")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar: {e}")
        return False
    finally:
        conexion.close()

# --------------------------------------------
# 6. Funciones para la tabla RUTINAS
# --------------------------------------------
def insertar_rutina(entrenador_id, nombre_rutina, descripcion):
    """Inserta una nueva rutina"""
    conexion = conectar_db()
    if not conexion:
        return None
    
    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO rutinas 
            (EntrenadorID, NombreRutina, Descripcion) 
            VALUES (?, ?, ?)""",
            (entrenador_id, nombre_rutina, descripcion)
        )
        rutina_id = cursor.lastrowid
        conexion.commit()
        print(f"Rutina creada (ID: {rutina_id})")
        return rutina_id
    except sqlite3.Error as e:
        print(f"Error: {e}")
        return None
    finally:
        conexion.close()

def eliminar_rutina(rutina_id):
    """Elimina una rutina por su ID"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM rutinas WHERE RutinaID = ?", (rutina_id,))
        conexion.commit()
        if cursor.rowcount > 0:
            print(f"Rutina {rutina_id} eliminada")
            return True
        else:
            print(f"No se encontró la rutina {rutina_id}")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar: {e}")
        return False
    finally:
        conexion.close()

# --------------------------------------------
# 7. Funciones para la tabla PAGOS
# --------------------------------------------
def insertar_pago(usuario_id, supervisor_id, monto, estado='Pendiente'):
    """Registra un nuevo pago"""
    conexion = conectar_db()
    if not conexion:
        return None
    
    try:
        cursor = conexion.cursor()
        cursor.execute(
            """INSERT INTO pagos 
            (UsuarioID, SupervisorID, Monto, Estado) 
            VALUES (?, ?, ?, ?)""",
            (usuario_id, supervisor_id, monto, estado)
        )
        pago_id = cursor.lastrowid
        conexion.commit()
        print(f"Pago registrado (ID: {pago_id})")
        return pago_id
    except sqlite3.Error as e:
        print(f"Error: {e}")
        return None
    finally:
        conexion.close()

def eliminar_pago(pago_id):
    """Elimina un pago por su ID"""
    conexion = conectar_db()
    if not conexion:
        return False
    
    try:
        cursor = conexion.cursor()
        cursor.execute("DELETE FROM pagos WHERE PagoID = ?", (pago_id,))
        conexion.commit()
        if cursor.rowcount > 0:
            print(f"Pago {pago_id} eliminado")
            return True
        else:
            print(f"No se encontró el pago {pago_id}")
            return False
    except sqlite3.Error as e:
        print(f"Error al eliminar: {e}")
        return False
    finally:
        conexion.close()

# --------------------------------------------
# 8. Funciones para las listas
# --------------------------------------------

def listar_todos_perfiles():
    """Obtiene todos los perfiles registrados"""
    conexion = conectar_db()
    if not conexion:
        return []
    
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT PerfilID, TipoPerfil, NombreCompleto, CorreoElectronico, 
                Telefono, FechaRegistro
            FROM perfiles
            ORDER BY TipoPerfil, NombreCompleto
        """)
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(f"Error al consultar perfiles: {e}")
        return []
    finally:
        conexion.close()

def listar_entrenadores():
    """Obtiene todos los entrenadores con sus especialidades"""
    conexion = conectar_db()
    if not conexion:
        return []
    
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT p.PerfilID, p.NombreCompleto, e.Especialidad, e.Certificacion
            FROM perfiles p
            JOIN perfilesEntrenadores e ON p.PerfilID = e.EntrenadorID
            ORDER BY p.NombreCompleto
        """)
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(f"Error al consultar entrenadores: {e}")
        return []
    finally:
        conexion.close()

def listar_usuarios():
    """Obtiene todos los usuarios con sus datos específicos"""
    conexion = conectar_db()
    if not conexion:
        return []
    
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT p.PerfilID, p.NombreCompleto
            FROM perfiles p
            JOIN perfilesUsuarios u ON p.PerfilID = u.UsuarioID
            ORDER BY p.NombreCompleto
        """)
        return cursor.fetchall()
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
        cursor.execute("SELECT COUNT(*) FROM perfilesUsuarios")
        return cursor.fetchone()[0]
    except sqlite3.Error as e:
        print(f"Error al contar usuarios: {e}")
        return 0
    finally:
        conexion.close()