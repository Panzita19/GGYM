from config.db_connection import conectar_db

class Pago:
    def __init__(self, usuario_id, supervisor_id, monto, estado='Pendiente', fecha_pago=None):
        self.usuario_id = usuario_id
        self.supervisor_id = supervisor_id
        self.monto = monto
        self.estado = estado
        self.fecha_pago = fecha_pago

    def insertar(self):
        conexion = conectar_db()
        if not conexion:
            return None
        try:
            cursor = conexion.cursor()

            cursor.execute("SELECT 1 FROM Usuarios WHERE UsuarioID = ?", (self.usuario_id,))
            if cursor.fetchone() is None:
                print(f"Error: El UsuarioID {self.usuario_id} no existe.")
                return None

            cursor.execute("SELECT 1 FROM Supervisores WHERE SupervisorID = ?", (self.supervisor_id,))
            if cursor.fetchone() is None:
                print(f"Error: El SupervisorID {self.supervisor_id} no existe.")
                return None

            cursor.execute("""
                INSERT INTO pagos
                (UsuarioID, SupervisorID, Monto, Estado, FechaPago)
                VALUES (?, ?, ?, ?, ?)""",
                (self.usuario_id, self.supervisor_id, self.monto, self.estado, self.fecha_pago)
            )
            conexion.commit()
            return cursor.lastrowid
        except Exception as e:
            print(f"Error al insertar pago: {e}")
            return None
        finally:
            conexion.close()

    @staticmethod
    def eliminar(pago_id):
        conexion = conectar_db()
        if not conexion:
            return False
        try:
            cursor = conexion.cursor()
            cursor.execute("DELETE FROM pagos WHERE PagoID = ?", (pago_id,))
            conexion.commit()
            return cursor.rowcount > 0
        except Exception as e:
            print(f"Error al eliminar pago: {e}")
            return False
        finally:
            conexion.close()
