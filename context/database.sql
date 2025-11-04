/*
================================================================================
 ARCHIVO DE CONTEXTO DE BASE DE DATOS (context/database.sql)
 Stack: PostgreSQL + PostGIS
 Misión: Definir la estructura de datos para el Sistema de Gestión de Riesgos.
================================================================================
*/

-- Habilitar la extensión PostGIS (Obligatorio para datos geográficos)
-- El Agente debe asegurarse de que esto esté habilitado en la base de datos.
CREATE EXTENSION IF NOT EXISTS postgis;

/*
================================================================================
 1. TIPOS ENUMERADOS (ENUMs)
 Define los estados y severidades permitidos para garantizar la integridad de datos.
================================================================================
*/
CREATE TYPE report_status AS ENUM (
    'recibido',      -- Reporte inicial del ciudadano, pendiente de revisión.
    'validado',      -- Analista confirmó el incidente.
    'asignado',      -- Gestor asignó una OT a un Ingeniero.
    'cerrado',        -- Obra finalizada y verificada.
    'descartado'     -- Reporte falso o duplicado.
);

CREATE TYPE report_severity AS ENUM (
    'baja',
    'media',
    'alta'
);

CREATE TYPE work_order_status AS ENUM (
    'pendiente',     -- Asignada, pero no iniciada.
    'en_progreso',   -- Ingeniero trabajando en sitio.
    'finalizada'     -- Ingeniero reportó 100% de avance.
);

/*
================================================================================
 2. TABLA DE USUARIOS (auth_user)
 Referencia: Usaremos la tabla 'auth_user' nativa de Django para la autenticación.
 El Agente debe usar los Roles (Groups) de Django para ('analista', 'gestor', 'ingeniero').
================================================================================
*/
-- (No crear 'auth_user' aquí, solo referenciarla en las Foreign Keys)


/*
================================================================================
 3. TABLA DE REPORTES (El incidente inicial)
 Almacena el reporte original del ciudadano.
================================================================================
*/
CREATE TABLE incident_report (
    id SERIAL PRIMARY KEY,
    
    -- Datos del incidente
    description TEXT NOT NULL,
    
    -- Campo Geográfico (PostGIS)
    -- SRID 4326 es el estándar WGS 84 (GPS Coords: Lat/Lon)
    location GEOMETRY(Point, 4326) NOT NULL,
    
    -- Evidencia (Ruta al archivo guardado en 'media')
    photo_path VARCHAR(512),
    
    -- Contacto (Opcional, para acuse de recibo)
    citizen_email VARCHAR(254),

    -- Estado y Severidad (Controlado por ENUMs)
    status report_status NOT NULL DEFAULT 'recibido',
    severity report_severity, -- Nulo hasta que el Analista lo asigne

    -- Timestamps de Trazabilidad (Mandatorio)
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    validated_at TIMESTAMPTZ, -- Timestamp de cuándo se validó
    assigned_at TIMESTAMPTZ,  -- Timestamp de cuándo se asignó OT
    closed_at TIMESTAMPTZ,    -- Timestamp de cierre final

    -- Auditoría (Quién validó el reporte)
    -- Referencia a la tabla nativa 'auth_user' de Django
    validator_id INTEGER REFERENCES auth_user(id) ON DELETE SET NULL
);

-- Índice Espacial (GIST)
-- Crucial para que las consultas de mapas (Leaflet) sean rápidas.
CREATE INDEX idx_incident_report_location ON incident_report USING GIST (location);


/*
================================================================================
 4. TABLA DE ÓRDENES DE TRABAJO (OT)
 El registro de la obra de mitigación asignada.
================================================================================
*/
CREATE TABLE work_order (
    id SERIAL PRIMARY KEY,

    -- Relación 1:1 con el reporte. Una OT solo existe si hay un reporte validado.
    report_id INTEGER UNIQUE NOT NULL REFERENCES incident_report(id) ON DELETE CASCADE,
    
    status work_order_status NOT NULL DEFAULT 'pendiente',

    -- Auditoría de Asignación (Quién asigna y a quién)
    assigner_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE RESTRICT, -- El Gestor
    engineer_id INTEGER REFERENCES auth_user(id) ON DELETE SET NULL,     -- El Ingeniero
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), -- Fecha de creación de la OT
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()  -- Para registrar el último avance
);


/*
================================================================================
 5. TABLA DE BITÁCORA DE OBRA (Evidencias)
 Almacena el historial inmutable de avances de la OT.
================================GET
*/
CREATE TABLE work_order_log (
    id SERIAL PRIMARY KEY,
    
    -- Relación N:1 con la OT. Una OT tiene múltiples bitácoras.
    order_id INTEGER NOT NULL REFERENCES work_order(id) ON DELETE CASCADE,
    
    -- Autor de la entrada (El Ingeniero)
    author_id INTEGER NOT NULL REFERENCES auth_user(id) ON DELETE RESTRICT,
    
    -- Contenido de la bitácora
    log_text TEXT NOT NULL,
    evidence_path VARCHAR(512), -- Ruta a fotos de avance
    
    -- Métrica de Avance
    progress_percentage SMALLINT NOT NULL DEFAULT 0 
        CHECK (progress_percentage >= 0 AND progress_percentage <= 100),

    -- Timestamp (Inmutable)
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


/*
================================================================================
 6. TABLA DE AUDITORÍA GENERAL (Log de Acciones)
 Registra acciones críticas (Ej. Login, Exportación de datos).
================================================================================
*/
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    
    -- Quién (Si está autenticado)
    user_id INTEGER REFERENCES auth_user(id) ON DELETE SET NULL,
    
    -- Qué
    action VARCHAR(255) NOT NULL, -- Ej: "USER_LOGIN_SUCCESS", "REPORT_EXPORTED"
    
    -- Dónde (IP)
    ip_address VARCHAR(45),
    
    -- Cuándo
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);