from config.db_connection import conectar_db

class Supervisor:
    def __init__(self, nombre_completo, cedula, correo, telefono, fecha_nacimiento, direccion):
        self.nombre_completo = nombre_completo
        self.cedula = cedula
        self.correo = correo
        self.telefono = telefono
        self.fecha_nacimiento = fecha_nacimiento
        self.direccion = direccion

    def insertar(self):
        conexion = conectar_db()
        if not conexion:
            return None
        try:
            cursor = conexion.cursor()
            cursor.execute("""
                INSERT INTO Supervisores
                (NombreCompleto, Cedula, Correo, Telefono, FechaNacimiento, Direccion)
                VALUES (?, ?, ?, ?, ?, ?)""",
                (self.nombre_completo, self.cedula, self.correo, self.telefono, self.fecha_nacimiento, self.direccion)
            )
            conexion.commit()
            return cursor.lastrowid
        except Exception as e:
            print(f"Error al insertar supervisor: {e}")
            return None
        finally:
            conexion.close()

    @staticmethod
    def eliminar(supervisor_id):
        conexion = conectar_db()
        if not conexion:
            return False
        try:
            cursor = conexion.cursor()
            cursor.execute("DELETE FROM Supervisores WHERE SupervisorID = ?", (supervisor_id,))
            conexion.commit()
            return cursor.rowcount > 0
        except Exception as e:
            print(f"Error al eliminar supervisor: {e}")
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
                SELECT SupervisorID, NombreCompleto, Cedula, Rol, Correo, Telefono, FechaNacimiento, Direccion, FechaRegistro
                FROM Supervisores
                ORDER BY NombreCompleto
            """)
            return [dict(row) for row in cursor.fetchall()]
        except Exception as e:
            print(f"Error al consultar supervisores: {e}")
            return []
        finally:
            conexion.close()
