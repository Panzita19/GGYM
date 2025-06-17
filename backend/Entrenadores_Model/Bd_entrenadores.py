from config.db_connection import conectar_db

class Entrenador:
    def __init__(self, nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion, especialidad, certificacion=None):
        self.nombre_completo = nombre_completo
        self.cedula = cedula
        self.correo = correo
        self.telefono = telefono
        self.fecha_nacimiento = fecha_nacimiento
        self.direccion = direccion
        self.especialidad = especialidad
        self.certificacion = certificacion

    def insertar(self):
        conexion = conectar_db()
        if not conexion:
            return None
        try:
            cursor = conexion.cursor()
            cursor.execute("""
                INSERT INTO Entrenadores
                (NombreCompleto, Cedula, Correo, Telefono, FechaNacimiento, Direccion, Especialidad, Certificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                (self.nombre_completo, self.cedula, self.correo, self.telefono, self.fecha_nacimiento,
                 self.direccion, self.especialidad, self.certificacion)
            )
            conexion.commit()
            return cursor.lastrowid
        except Exception as e:
            print(f"Error al insertar entrenador: {e}")
            return None
        finally:
            conexion.close()

    @staticmethod
    def eliminar(entrenador_id):
        conexion = conectar_db()
        if not conexion:
            return False
        try:
            cursor = conexion.cursor()
            cursor.execute("DELETE FROM Entrenadores WHERE EntrenadorID = ?", (entrenador_id,))
            conexion.commit()
            return cursor.rowcount > 0
        except Exception as e:
            print(f"Error al eliminar entrenador: {e}")
            return False
        finally:
            conexion.close()

    @staticmethod
    def listar():
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
        except Exception as e:
            print(f"Error al consultar entrenadores: {e}")
            return []
        finally:
            conexion.close()
