--
-- Archivo generado con SQLiteStudio v3.4.17 el Sun May 25 22:49:55 2025
--
-- Codificación de texto usada: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Tabla: Entrenadores
CREATE TABLE IF NOT EXISTS Entrenadores(
    EntrenadorID INTEGER PRIMARY KEY AUTOINCREMENT, 
    NombreCompleto TEXT NOT NULL,
    Rol TEXT DEFAULT 'Entrenador',
    Correo TEXT NOT NULL UNIQUE,
    Telefono TEXT NOT NULL,
    FechaNacimiento TEXT NOT NULL,
    FechaRegistro TEXT DEFAULT CURRENT_DATE,
    Direccion TEXT,
    Especialidad TEXT NOT NULL, 
    Certificacion TEXT 
);

-- Tabla: pagos
CREATE TABLE IF NOT EXISTS pagos (
    PagoID INTEGER PRIMARY KEY AUTOINCREMENT,
    UsuarioID INTEGER NOT NULL,
    SupervisorID INTEGER NOT NULL,
    Monto REAL NOT NULL,
    Estado TEXT DEFAULT 'Pendiente' CHECK (Estado IN ('Pendiente', 'Aprobado', 'Rechazado')),
    FechaPago TEXT,
    FOREIGN KEY (UsuarioID) REFERENCES perfilesUsuarios(UsuarioID),
    FOREIGN KEY (SupervisorID) REFERENCES perfilesSupervisores(SupervisorID)
);

-- Tabla: planes
CREATE TABLE IF NOT EXISTS planes (
    idPlanes INTEGER PRIMARY KEY AUTOINCREMENT,
    duracion TEXT,
    monto REAL,
    descripcion TEXT,
    beneficios TEXT
);

-- Tabla: rutinas
CREATE TABLE IF NOT EXISTS rutinas (RutinaID INTEGER PRIMARY KEY AUTOINCREMENT, EntrenadorID INTEGER NOT NULL, NombreRutina TEXT NOT NULL, Descripcion TEXT, FechaCreacion TEXT DEFAULT CURRENT_DATE, FOREIGN KEY (EntrenadorID) REFERENCES perfilesEntrenadores (EntrenadorID));

-- Tabla: Supervisores
CREATE TABLE IF NOT EXISTS Supervisores(
    SupervisorID INTEGER PRIMARY KEY AUTOINCREMENT, 
    NombreCompleto TEXT NOT NULL,
    Rol TEXT DEFAULT 'Supervisor',
    Correo TEXT NOT NULL UNIQUE,
    Telefono TEXT NOT NULL,
    FechaNacimiento TEXT NOT NULL,
    FechaRegistro TEXT DEFAULT CURRENT_DATE,
    Direccion TEXT
);

-- Tabla: Usuarios
CREATE TABLE IF NOT EXISTS Usuarios(
    UsuarioID INTEGER PRIMARY KEY AUTOINCREMENT, 
    NombreCompleto TEXT NOT NULL,
    Rol TEXT DEFAULT 'Usuario',
    Correo TEXT NOT NULL UNIQUE,
    Telefono TEXT NOT NULL,
    FechaNacimiento TEXT NOT NULL,
    FechaRegistro TEXT DEFAULT CURRENT_DATE,
    Direccion TEXT
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
