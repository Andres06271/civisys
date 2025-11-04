# 🏗️ ARCHITECTURE.md - Arquitectura del Sistema Civisys

**Versión:** 1.0  
**Fecha:** 2025-11-04  
**Autor:** Equipo Civisys

---

## 📋 Índice

1. [Arquitectura de Alto Nivel](#1-arquitectura-de-alto-nivel)
2. [Stack Tecnológico](#2-stack-tecnológico)
3. [Arquitectura de Componentes](#3-arquitectura-de-componentes)
4. [Modelo de Datos](#4-modelo-de-datos)
5. [Flujos de Datos Principales](#5-flujos-de-datos-principales)
6. [Diagramas de Secuencia](#6-diagramas-de-secuencia)
7. [Decisiones de Arquitectura](#7-decisiones-de-arquitectura)
8. [Seguridad y Auditoría](#8-seguridad-y-auditoría)

---

## 1. Arquitectura de Alto Nivel

### 1.1. Vista General del Sistema

```mermaid
graph TB
    subgraph "Cliente (Frontend)"
        A[Ciudadano<br/>Navegador Web/Móvil]
        B[Analista<br/>Dashboard Web]
        C[Gestor Local<br/>Panel Administrativo]
        D[Ingeniero<br/>Aplicación Web]
    end
    
    subgraph "Capa de Presentación"
        E[Django Templates<br/>Bootstrap 5]
        F[Leaflet.js<br/>OpenStreetMap]
    end
    
    subgraph "Capa de Aplicación (Django)"
        G[Django Views<br/>Lógica de Negocio]
        H[Django REST Framework<br/>API REST]
        I[Autenticación<br/>Django Auth]
        J[Permisos y Roles<br/>Django Permissions]
    end
    
    subgraph "Capa de Datos"
        K[PostgreSQL<br/>PostGIS Extension]
        L[Media Files<br/>Almacenamiento Local]
    end
    
    subgraph "Servicios Externos"
        M[SMTP Server<br/>Notificaciones Email]
    end
    
    A --> E
    B --> E
    C --> E
    D --> E
    E --> F
    E --> G
    G --> H
    G --> I
    I --> J
    G --> K
    G --> L
    G --> M
    
    style A fill:#e1f5ff
    style B fill:#fff4e1
    style C fill:#ffe1f5
    style D fill:#e1ffe1
    style K fill:#f0f0f0
```

### 1.2. Capas del Sistema

| Capa | Tecnología | Responsabilidad |
|------|-----------|-----------------|
| **Presentación** | HTML5, CSS3, Bootstrap 5, JavaScript, Leaflet.js | Interfaz de usuario, visualización de mapas, responsive design |
| **Aplicación** | Django 4+, Django REST Framework | Lógica de negocio, autenticación, autorización, validación |
| **Datos** | PostgreSQL + PostGIS | Almacenamiento persistente, consultas geográficas |
| **Almacenamiento** | Sistema de archivos local | Media files (fotos, documentos) |
| **Comunicación** | SMTP (Gmail/SendGrid gratuito) | Notificaciones por correo electrónico |

---

## 2. Stack Tecnológico

### 2.1. Backend

```python
# Framework Principal
Django 4.2+                    # Framework web robusto
Django REST Framework 3.14+    # API REST (si se requiere)
django-cors-headers            # CORS para frontend
django-gis                     # Integración PostGIS nativa

# Base de Datos
psycopg2-binary               # Driver PostgreSQL
PostGIS 3.0+                  # Extensión geográfica

# Autenticación y Seguridad
django-allauth (opcional)      # Si se requiere OAuth
django-ratelimit               # Rate limiting
argon2-cffi                    # Hash de contraseñas (recomendado)

# Utilidades
python-decouple                # Manejo de variables de entorno
Pillow                         # Procesamiento de imágenes
reportlab                      # Generación de PDFs
```

### 2.2. Frontend

```javascript
// CSS Framework
Bootstrap 5.3+                 // Mobile-first, responsive

// Mapas
Leaflet.js 1.9+                // Librería de mapas ligera
Leaflet.draw                   // Dibujo en mapas (opcional)

// JavaScript
Vanilla JS (ES6+)              // Sin frameworks pesados (baja conectividad)
```

### 2.3. Base de Datos

```
PostgreSQL 14+
PostGIS 3.0+                   // Extensión para datos geográficos
```

---

## 3. Arquitectura de Componentes

### 3.1. Estructura de Apps Django

```mermaid
graph LR
    subgraph "Civisys Project"
        A[civisys/<br/>settings.py<br/>urls.py<br/>wsgi.py]
    end
    
    subgraph "Django Apps"
        B[reports/<br/>Reportes de Incidentes]
        C[work_orders/<br/>Órdenes de Trabajo]
        D[authentication/<br/>Autenticación y Roles]
        E[dashboard/<br/>Panel Administrativo]
        F[api/<br/>API REST - Opcional]
        G[audit/<br/>Auditoría y Logs]
    end
    
    A --> B
    A --> C
    A --> D
    A --> E
    A --> F
    A --> G
    
    B --> C
    C --> D
    E --> B
    E --> C
    F --> B
    F --> C
    G --> D
    
    style A fill:#4a90e2
    style B fill:#e8f4f8
    style C fill:#e8f4f8
    style D fill:#e8f4f8
    style E fill:#e8f4f8
    style F fill:#e8f4f8
    style G fill:#e8f4f8
```

### 3.2. Responsabilidades por App

| App Django | Responsabilidad | Modelos Principales |
|------------|-----------------|---------------------|
| **reports** | Gestión de reportes de incidentes | `IncidentReport` |
| **work_orders** | Gestión de órdenes de trabajo y bitácoras | `WorkOrder`, `WorkOrderLog` |
| **authentication** | Autenticación, roles y permisos | Extiende `auth.User`, `Groups` |
| **dashboard** | Paneles administrativos y estadísticas | Vistas y agregaciones |
| **api** | API REST (opcional para futuras integraciones) | Serializers, ViewSets |
| **audit** | Logs de auditoría y trazabilidad | `AuditLog` |

---

## 4. Modelo de Datos

### 4.1. Diagrama Entidad-Relación (ER)

```mermaid
erDiagram
    auth_user ||--o{ incident_report : "valida"
    auth_user ||--o{ work_order : "asigna"
    auth_user ||--o{ work_order : "ejecuta"
    auth_user ||--o{ work_order_log : "escribe"
    auth_user ||--o{ audit_log : "realiza"
    
    incident_report ||--|| work_order : "genera"
    work_order ||--o{ work_order_log : "tiene"
    
    auth_user {
        int id PK
        string username
        string email
        string password_hash
        datetime date_joined
    }
    
    incident_report {
        int id PK
        text description
        geometry location "PostGIS Point"
        string photo_path
        string citizen_email
        enum status "recibido|validado|asignado|cerrado|descartado"
        enum severity "baja|media|alta"
        datetime created_at
        datetime validated_at
        datetime assigned_at
        datetime closed_at
        int validator_id FK
    }
    
    work_order {
        int id PK
        int report_id FK "UNIQUE"
        enum status "pendiente|en_progreso|finalizada"
        int assigner_id FK
        int engineer_id FK
        datetime created_at
        datetime updated_at
    }
    
    work_order_log {
        int id PK
        int order_id FK
        int author_id FK
        text log_text
        string evidence_path
        smallint progress_percentage
        datetime created_at
    }
    
    audit_log {
        int id PK
        int user_id FK
        string action
        string ip_address
        datetime created_at
    }
```

### 4.2. Relaciones Clave

| Relación | Tipo | Descripción |
|----------|------|-------------|
| `incident_report` → `work_order` | **1:1** | Un reporte validado genera una única orden de trabajo |
| `work_order` → `work_order_log` | **1:N** | Una orden puede tener múltiples entradas de bitácora |
| `auth_user` → `incident_report` | **1:N** | Un analista puede validar múltiples reportes |
| `auth_user` → `work_order` | **1:N** | Un gestor puede asignar múltiples órdenes |
| `auth_user` → `work_order_log` | **1:N** | Un ingeniero puede escribir múltiples bitácoras |

---

## 5. Flujos de Datos Principales

### 5.1. Flujo de Reporte de Incidente

```mermaid
flowchart TD
    Start([Ciudadano reporta incidente]) --> A[Formulario Web]
    A --> B{Validación de datos}
    B -->|Válido| C[Guardar en BD]
    B -->|Inválido| A
    C --> D[Generar ID único]
    D --> E[Enviar acuse de recibo<br/>Email opcional]
    E --> F[Estado: recibido]
    F --> G[Analista revisa]
    G --> H{¿Es válido?}
    H -->|Sí| I[Validar reporte]
    H -->|No| J[Descartar]
    I --> K[Estado: validado<br/>Asignar severidad]
    K --> L[Gestor asigna OT]
    L --> M[Estado: asignado]
    M --> End([OT creada])
    
    style Start fill:#e1f5ff
    style End fill:#e1ffe1
    style I fill:#fff4e1
    style L fill:#ffe1f5
```

### 5.2. Flujo de Gestión de Orden de Trabajo

```mermaid
flowchart TD
    Start([Gestor crea OT]) --> A[Asociar a reporte validado]
    A --> B[Asignar ingeniero]
    B --> C[Estado: pendiente]
    C --> D[Notificar ingeniero]
    D --> E[Ingeniero inicia trabajo]
    E --> F[Estado: en_progreso]
    F --> G[Ingeniero registra avance]
    G --> H[Crear entrada en bitácora]
    H --> I{Finalizado?}
    I -->|No| G
    I -->|Sí 100%| J[Estado: finalizada]
    J --> K[Verificación final]
    K --> L[Cerrar reporte]
    L --> M[Estado: cerrado]
    M --> End([Proceso completo])
    
    style Start fill:#ffe1f5
    style End fill:#e1ffe1
    style G fill:#e1ffe1
```

---

## 6. Diagramas de Secuencia

### 6.1. Secuencia: Reporte de Incidente por Ciudadano

```mermaid
sequenceDiagram
    participant C as Ciudadano
    participant W as Web Browser
    participant V as Django View
    participant M as Model (IncidentReport)
    participant DB as PostgreSQL
    participant E as Email Service
    
    C->>W: Accede a formulario de reporte
    W->>V: GET /report/create
    V->>W: Renderizar formulario
    W->>C: Mostrar formulario
    
    C->>W: Completa formulario (ubicación, descripción, foto)
    W->>V: POST /report/create
    V->>V: Validar datos
    V->>V: Validar coordenadas geográficas
    V->>M: Crear IncidentReport
    M->>DB: INSERT INTO incident_report
    DB-->>M: ID generado
    M-->>V: Reporte creado (ID, fecha)
    V->>E: Enviar acuse de recibo (si email proporcionado)
    E-->>C: Email de confirmación
    V->>W: Redirigir a página de confirmación
    W->>C: Mostrar mensaje de éxito con ID
```

### 6.2. Secuencia: Validación de Reporte por Analista

```mermaid
sequenceDiagram
    participant A as Analista
    participant W as Web Browser
    participant V as Django View
    participant M as Model (IncidentReport)
    participant DB as PostgreSQL
    participant AL as AuditLog
    
    A->>W: Accede a dashboard de reportes
    W->>V: GET /reports/pending
    V->>M: Consultar reportes con status='recibido'
    M->>DB: SELECT * FROM incident_report WHERE status='recibido'
    DB-->>M: Lista de reportes
    M-->>V: Reportes pendientes
    V->>W: Renderizar lista
    W->>A: Mostrar reportes pendientes
    
    A->>W: Selecciona reporte y valida
    W->>V: POST /reports/{id}/validate
    V->>V: Verificar permisos (rol: analista)
    V->>M: Actualizar reporte
    M->>DB: UPDATE incident_report SET status='validado', severity=?, validator_id=?, validated_at=NOW()
    DB-->>M: Actualizado
    M-->>V: Reporte validado
    V->>AL: Registrar acción de auditoría
    AL->>DB: INSERT INTO audit_log
    V->>W: Redirigir a dashboard
    W->>A: Mostrar confirmación
```

### 6.3. Secuencia: Asignación de Orden de Trabajo por Gestor

```mermaid
sequenceDiagram
    participant G as Gestor
    participant W as Web Browser
    participant V as Django View
    participant WR as Model (WorkOrder)
    participant IR as Model (IncidentReport)
    participant DB as PostgreSQL
    participant E as Email Service
    
    G->>W: Accede a reportes validados
    W->>V: GET /work-orders/create/{report_id}
    V->>IR: Obtener reporte validado
    IR->>DB: SELECT * FROM incident_report WHERE id=?
    DB-->>IR: Datos del reporte
    IR-->>V: Reporte validado
    V->>W: Renderizar formulario de OT
    
    G->>W: Selecciona ingeniero y crea OT
    W->>V: POST /work-orders/create
    V->>V: Verificar permisos (rol: gestor)
    V->>WR: Crear WorkOrder
    WR->>DB: INSERT INTO work_order (report_id, assigner_id, engineer_id)
    DB-->>WR: OT creada
    WR-->>V: OT creada
    V->>IR: Actualizar estado del reporte
    IR->>DB: UPDATE incident_report SET status='asignado', assigned_at=NOW()
    V->>E: Notificar ingeniero asignado
    E-->>Ingeniero: Email de asignación
    V->>W: Redirigir a dashboard
    W->>G: Mostrar confirmación
```

### 6.4. Secuencia: Registro de Avance por Ingeniero

```mermaid
sequenceDiagram
    participant I as Ingeniero
    participant W as Web Browser
    participant V as Django View
    participant WOL as Model (WorkOrderLog)
    participant WO as Model (WorkOrder)
    participant DB as PostgreSQL
    participant AL as AuditLog
    
    I->>W: Accede a sus órdenes de trabajo
    W->>V: GET /work-orders/my-orders
    V->>WO: Consultar OTs del ingeniero
    WO->>DB: SELECT * FROM work_order WHERE engineer_id=?
    DB-->>WO: Órdenes asignadas
    WO-->>V: Lista de OTs
    V->>W: Renderizar lista
    W->>I: Mostrar órdenes de trabajo
    
    I->>W: Selecciona OT y registra avance
    W->>V: POST /work-orders/{id}/log
    V->>V: Verificar permisos (rol: ingeniero, OT asignada)
    V->>V: Validar datos (progreso 0-100%, texto obligatorio)
    V->>WOL: Crear WorkOrderLog
    WOL->>DB: INSERT INTO work_order_log (order_id, author_id, log_text, progress_percentage, evidence_path)
    DB-->>WOL: Log creado
    WOL-->>V: Log creado
    
    V->>WO: Actualizar estado si progreso = 100%
    alt progreso = 100%
        WO->>DB: UPDATE work_order SET status='finalizada', updated_at=NOW()
    else progreso < 100% y status = 'pendiente'
        WO->>DB: UPDATE work_order SET status='en_progreso', updated_at=NOW()
    end
    
    V->>AL: Registrar acción de auditoría
    AL->>DB: INSERT INTO audit_log
    V->>W: Redirigir a detalle de OT
    W->>I: Mostrar confirmación y nuevo log
```

---

## 7. Decisiones de Arquitectura

### 7.1. Patrón MVC de Django

**Decisión:** Usar el patrón MVT (Model-View-Template) nativo de Django.

**Justificación:**
- Separación clara de responsabilidades
- ORM de Django facilita el trabajo con PostGIS
- Templates reutilizables y fáciles de mantener
- Sistema de autenticación integrado

### 7.2. Base de Datos: PostgreSQL + PostGIS

**Decisión:** PostgreSQL con extensión PostGIS en lugar de SQLite.

**Justificación:**
- PostGIS es el estándar para datos geográficos
- Soporte nativo para consultas espaciales (ST_Distance, ST_Within, etc.)
- Índices GIST para optimizar búsquedas geográficas
- Escalabilidad y robustez para producción

### 7.3. Frontend: Bootstrap 5 (Sin Framework JS)

**Decisión:** Bootstrap 5 sin frameworks JavaScript pesados (React, Vue, Angular).

**Justificación:**
- **Baja conectividad:** Los usuarios en zonas rurales necesitan interfaces ligeras
- **Mobile-first:** Bootstrap 5 es responsive por defecto
- **Rápido de cargar:** Menor tiempo de carga mejora la experiencia
- **Fácil mantenimiento:** Menos dependencias y complejidad

### 7.4. Mapas: Leaflet.js + OpenStreetMap

**Decisión:** Leaflet.js con OpenStreetMap en lugar de Google Maps.

**Justificación:**
- **Costo cero:** OpenStreetMap es gratuito, Google Maps requiere API key con costos
- **Ligero:** Leaflet.js es más liviano que alternativas
- **Open Source:** Control total sobre la implementación
- **Offline-capable:** Puede funcionar con tiles precargadas

### 7.5. Autenticación: Django Auth Nativo

**Decisión:** Usar el sistema de autenticación nativo de Django con Groups.

**Justificación:**
- Ya incluido en Django, sin dependencias adicionales
- Sistema de permisos robusto
- Fácil de extender con custom user model si se requiere
- Seguridad probada (Argon2 para hashing de contraseñas)

### 7.6. Almacenamiento de Media: Sistema de Archivos Local

**Decisión:** Almacenar archivos (fotos) en el sistema de archivos local.

**Justificación:**
- **Costo cero:** No requiere servicios de almacenamiento en la nube pagados
- **Simplicidad:** Django maneja esto nativamente
- **Rendimiento:** Acceso directo a archivos es rápido

**Nota:** Para producción, considerar migración a S3-compatible gratuito (MinIO) si se requiere escalabilidad.

---

## 8. Seguridad y Auditoría

### 8.1. Capas de Seguridad

```mermaid
graph TB
    subgraph "Capa 1: Frontend"
        A[Validación HTML5]
        B[CSRF Tokens]
        C[XSS Protection]
    end
    
    subgraph "Capa 2: Django Middleware"
        D[Authentication Middleware]
        E[Permission Checks]
        F[CSRF Protection]
        G[Security Headers]
    end
    
    subgraph "Capa 3: Views"
        H[Decoradores de Permisos]
        I[Validación de Datos]
        J[Rate Limiting]
    end
    
    subgraph "Capa 4: Base de Datos"
        K[Índices Espaciales]
        L[Foreign Key Constraints]
        M[Enum Constraints]
    end
    
    A --> D
    B --> F
    C --> G
    D --> H
    E --> H
    F --> I
    G --> I
    H --> K
    I --> L
    J --> M
    
    style A fill:#ffe1f5
    style D fill:#fff4e1
    style H fill:#e1ffe1
    style K fill:#e1f5ff
```

### 8.2. Auditoría y Trazabilidad

**Principios:**
- **Inmutabilidad:** Los logs de auditoría no se modifican ni eliminan
- **Completitud:** Toda acción crítica genera un registro
- **Atribución:** Cada acción está asociada a un usuario (si está autenticado)
- **Temporalidad:** Timestamps precisos para análisis posterior

**Acciones Auditadas:**
- Login exitoso/fallido
- Validación de reportes
- Creación de órdenes de trabajo
- Actualización de avances
- Exportación de datos
- Cambios de permisos

---

## 9. Escalabilidad Futura

### 9.1. Consideraciones para Escalado

**Fase 1 (MVP - Actual):**
- Servidor único
- PostgreSQL local
- Archivos en sistema de archivos

**Fase 2 (Crecimiento):**
- Servidor de aplicación separado
- Base de datos dedicada
- CDN para archivos estáticos (Cloudflare gratuito)
- Caché Redis (opcional)

**Fase 3 (Alta Demanda):**
- Load balancer
- Múltiples instancias de Django
- Replicación de base de datos
- Almacenamiento S3-compatible (MinIO)

### 9.2. Optimizaciones Geográficas

- **Índices GIST:** Ya implementados para consultas espaciales
- **Clustering:** Agrupar reportes cercanos en mapas
- **Caché de tiles:** Precargar tiles de OpenStreetMap para zonas frecuentes
- **Lazy loading:** Cargar reportes del mapa según zoom level

---

## 10. Referencias

- **Esquema de Base de Datos:** `/context/database.sql`
- **Guía para Agentes:** `/agents.md`
- **Documentación del Proyecto:** `/README.md`
- **Django GIS Documentation:** https://docs.djangoproject.com/en/stable/ref/contrib/gis/
- **PostGIS Documentation:** https://postgis.net/documentation/

---

**Última actualización:** 2025-11-04  
**Mantenido por:** Equipo de Desarrollo Civisys

