from config.db_connection import conectar_db

class Rutina:
    def __init__(self, entrenador_id, nombre_rutina, descripcion=None):
        self.entrenador_id = entrenador_id
        self.nombre_rutina = nombre_rutina
        self.descripcion = descripcion

    def insertar(self):
        conexion = conectar_db()
        if not conexion:
            return None
        try:
            cursor = conexion.cursor()
            cursor.execute("SELECT 1 FROM Entrenadores WHERE EntrenadorID = ?", (self.entrenador_id,))
            if cursor.fetchone() is None:
                print(f"Error: El EntrenadorID {self.entrenador_id} no existe.")
                return None

            cursor.execute("""
                INSERT INTO rutinas
                (EntrenadorID, NombreRutina, Descripcion)
                VALUES (?, ?, ?)""",
                (self.entrenador_id, self.nombre_rutina, self.descripcion)
            )
            conexion.commit()
            return cursor.lastrowid
        except Exception as e:
            print(f"Error al insertar rutina: {e}")
            return None
        finally:
            conexion.close()

    @staticmethod
    def eliminar(rutina_id):
        conexion = conectar_db()
        if not conexion:
            return False
        try:
            cursor = conexion.cursor()
            cursor.execute("DELETE FROM rutinas WHERE RutinaID = ?", (rutina_id,))
            conexion.commit()
            return cursor.rowcount > 0
        except Exception as e:
            print(f"Error al eliminar rutina: {e}")
            return False
        finally:
            conexion.close()

    @staticmethod
    def listar_por_entrenador(entrenador_id):
        conexion = conectar_db()
        if not conexion:
            return []
        try:
            cursor = conexion.cursor()
            cursor.execute("""
                SELECT RutinaID, EntrenadorID, NombreRutina, Descripcion
                FROM rutinas
                WHERE EntrenadorID = ?
                ORDER BY RutinaID DESC
            """, (entrenador_id,))
            return [dict(row) for row in cursor.fetchall()]
        except Exception as e:
            print(f"Error al listar rutinas del entrenador: {e}")
            return []
        finally:
            conexion.close()
