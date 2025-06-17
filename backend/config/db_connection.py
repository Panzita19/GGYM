import sqlite3
import os

def conectar_db():
    db_path = "IS.db"
    if not os.path.exists(db_path):
        print(f"ADVERTENCIA: Archivo de base de datos '{db_path}' no encontrado al intentar conectar.")
        return None
    try:
        conexion = sqlite3.connect(db_path)
        conexion.execute("PRAGMA foreign_keys = ON;")
        conexion.row_factory = sqlite3.Row
        return conexion
    except sqlite3.Error as error:
        print(f"Error de conexión: {error}")
        return None
