from config.db_connection import conectar_db

class Plan:
    def __init__(self, duracion, monto, descripcion=None, beneficios=None):
        self.duracion = duracion
        self.monto = monto
        self.descripcion = descripcion
        self.beneficios = beneficios

    def insertar(self):
        conexion = conectar_db()
        if not conexion:
            return None
        try:
            cursor = conexion.cursor()
            cursor.execute("""
                INSERT INTO planes (duracion, monto, descripcion, beneficios)
                VALUES (?, ?, ?, ?)""",
                (self.duracion, self.monto, self.descripcion, self.beneficios)
            )
            conexion.commit()
            return cursor.lastrowid
        except Exception as e:
            print(f"Error al insertar plan: {e}")
            return None
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
                SELECT idPlanes, duracion, monto, descripcion, beneficios
                FROM planes
                ORDER BY idPlanes
            """)
            return [dict(row) for row in cursor.fetchall()]
        except Exception as e:
            print(f"Error al listar planes: {e}")
            return []
        finally:
            conexion.close()
