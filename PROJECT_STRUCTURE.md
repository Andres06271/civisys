# 📁 PROJECT_STRUCTURE.md - Estructura del Proyecto Django Civisys

**Versión:** 1.0  
**Fecha:** 2025-11-04  
**Autor:** Equipo Civisys

---

## 📋 Índice

1. [Estructura General](#1-estructura-general)
2. [Estructura de Directorios](#2-estructura-de-directorios)
3. [Apps Django](#3-apps-django)
4. [Archivos de Configuración](#4-archivos-de-configuración)
5. [Templates y Static Files](#5-templates-y-static-files)
6. [Media Files](#6-media-files)
7. [Tests](#7-tests)
8. [Convenciones de Nombres](#8-convenciones-de-nombres)
9. [Archivos de Entorno](#9-archivos-de-entorno)

---

## 1. Estructura General

### 1.1. Vista General del Proyecto

```
civisys/
├── civisys/              # Proyecto Django principal
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
│
├── reports/              # App: Reportes de incidentes
├── work_orders/           # App: Órdenes de trabajo
├── authentication/        # App: Autenticación y roles
├── dashboard/            # App: Paneles administrativos
├── api/                  # App: API REST (opcional)
├── audit/                # App: Auditoría y logs
│
├── templates/            # Templates HTML globales
├── static/               # Archivos estáticos (CSS, JS, imágenes)
├── media/                # Archivos subidos por usuarios (fotos, documentos)
│
├── tests/                # Tests de integración
├── context/              # Archivos de contexto (database.sql, etc.)
├── scripts/              # Scripts de utilidad
│
├── .env                  # Variables de entorno (no versionado)
├── .env.example          # Ejemplo de variables de entorno
├── .gitignore            # Archivos ignorados por Git
├── requirements.txt      # Dependencias Python
├── README.md             # Documentación principal
├── ARCHITECTURE.md       # Arquitectura del sistema
├── USER_STORIES.md       # Historias de usuario
├── PROJECT_PLAN.md       # Plan de proyecto
├── RISK_ANALYSIS.md      # Análisis de riesgos
├── PROJECT_STRUCTURE.md  # Este documento
├── agents.md             # Guía para agentes
└── manage.py             # Script de gestión Django
```

---

## 2. Estructura de Directorios

### 2.1. Directorio Raíz (`civisys/`)

```
civisys/
├── .git/                 # Control de versiones Git
├── .gitignore            # Archivos ignorados
├── .env                  # Variables de entorno (NO versionar)
├── .env.example          # Ejemplo de variables de entorno
├── README.md             # Documentación principal
├── ARCHITECTURE.md       # Arquitectura del sistema
├── USER_STORIES.md       # Historias de usuario
├── PROJECT_PLAN.md       # Plan de proyecto
├── RISK_ANALYSIS.md      # Análisis de riesgos
├── PROJECT_STRUCTURE.md  # Este documento
├── agents.md             # Guía para agentes
├── requirements.txt      # Dependencias Python
├── manage.py             # Script de gestión Django
│
├── civisys/              # Proyecto Django principal
│   ├── __init__.py
│   ├── settings/
│   │   ├── __init__.py
│   │   ├── base.py       # Configuración base
│   │   ├── development.py # Configuración desarrollo
│   │   └── production.py # Configuración producción
│   ├── urls.py           # URLs principales
│   ├── wsgi.py           # WSGI config
│   └── asgi.py           # ASGI config (opcional)
│
├── reports/              # App: Reportes de incidentes
├── work_orders/          # App: Órdenes de trabajo
├── authentication/       # App: Autenticación y roles
├── dashboard/            # App: Paneles administrativos
├── api/                  # App: API REST (opcional, Fase 3)
├── audit/                # App: Auditoría y logs
│
├── templates/            # Templates HTML globales
│   ├── base.html
│   ├── reports/
│   ├── work_orders/
│   ├── authentication/
│   └── dashboard/
│
├── static/               # Archivos estáticos
│   ├── css/
│   ├── js/
│   ├── images/
│   └── vendor/           # Librerías externas (Bootstrap, Leaflet)
│
├── media/                # Archivos subidos por usuarios
│   ├── reports/
│   │   └── photos/       # Fotos de reportes
│   └── work_orders/
│       └── evidence/     # Fotos de evidencia de obras
│
├── tests/                # Tests de integración
│   ├── __init__.py
│   ├── test_reports.py
│   ├── test_work_orders.py
│   └── test_authentication.py
│
├── context/              # Archivos de contexto
│   └── database.sql       # Esquema de base de datos
│
└── scripts/              # Scripts de utilidad
    ├── setup_db.py       # Script para configurar BD
    ├── create_superuser.py
    └── seed_data.py      # Datos de prueba (opcional)
```

---

## 3. Apps Django

### 3.1. Estructura de una App Django

Cada app Django sigue esta estructura estándar:

```
app_name/
├── __init__.py
├── admin.py              # Configuración del admin de Django
├── apps.py               # Configuración de la app
├── models.py             # Modelos de datos
├── views.py              # Vistas (lógica de negocio)
├── urls.py               # URLs de la app
├── forms.py              # Formularios (si aplica)
├── serializers.py        # Serializers para API (si aplica)
├── permissions.py        # Permisos personalizados (si aplica)
├── utils.py              # Utilidades de la app
│
├── migrations/           # Migraciones de base de datos
│   ├── __init__.py
│   └── 0001_initial.py
│
├── tests/                # Tests de la app
│   ├── __init__.py
│   ├── test_models.py
│   ├── test_views.py
│   └── test_forms.py
│
└── templates/            # Templates de la app
    └── app_name/
        ├── list.html
        ├── detail.html
        └── form.html
```

### 3.2. App: `reports/` - Reportes de Incidentes

**Responsabilidad:** Gestión de reportes de incidentes de derrumbe

```
reports/
├── __init__.py
├── admin.py              # Admin de IncidentReport
├── apps.py
├── models.py             # IncidentReport model
├── views.py              # Vistas de reportes (create, list, detail)
├── urls.py               # URLs: /report/create, /report/<id>/, etc.
├── forms.py              # Formulario de reporte de incidente
├── permissions.py        # Permisos para reportes
├── utils.py              # Utilidades (generar ID único, validar coordenadas)
│
├── migrations/
│   └── ...
│
├── tests/
│   ├── test_models.py    # Tests de modelo IncidentReport
│   ├── test_views.py     # Tests de vistas de reportes
│   ├── test_forms.py     # Tests de formularios
│   └── test_permissions.py
│
└── templates/
    └── reports/
        ├── create.html   # Formulario de reporte
        ├── detail.html   # Detalle de reporte
        ├── list.html     # Lista de reportes (admin)
        └── status.html   # Consulta de estado por ID
```

**Modelos Principales:**
- `IncidentReport`: Reporte de incidente con ubicación geográfica

**Vistas Principales:**
- `ReportCreateView`: Crear reporte (público)
- `ReportDetailView`: Ver detalle de reporte
- `ReportStatusView`: Consultar estado por ID (público)
- `ReportListView`: Lista de reportes (autenticado)

---

### 3.3. App: `work_orders/` - Órdenes de Trabajo

**Responsabilidad:** Gestión de órdenes de trabajo y bitácoras

```
work_orders/
├── __init__.py
├── admin.py              # Admin de WorkOrder, WorkOrderLog
├── apps.py
├── models.py             # WorkOrder, WorkOrderLog models
├── views.py              # Vistas de OTs (create, assign, list, log)
├── urls.py               # URLs: /work-orders/, /work-orders/<id>/log/, etc.
├── forms.py              # Formularios de OT y bitácora
├── permissions.py       # Permisos para OTs
├── utils.py              # Utilidades (validar porcentaje, actualizar estado)
│
├── migrations/
│   └── ...
│
├── tests/
│   ├── test_models.py    # Tests de WorkOrder, WorkOrderLog
│   ├── test_views.py     # Tests de vistas de OTs
│   └── test_forms.py
│
└── templates/
    └── work_orders/
        ├── create.html   # Crear OT
        ├── list.html     # Lista de OTs
        ├── detail.html   # Detalle de OT
        ├── my_orders.html # Mis OTs (ingeniero)
        └── log_form.html  # Formulario de bitácora
```

**Modelos Principales:**
- `WorkOrder`: Orden de trabajo vinculada a un reporte
- `WorkOrderLog`: Entrada de bitácora de avance de obra

**Vistas Principales:**
- `WorkOrderCreateView`: Crear OT (gestor)
- `WorkOrderAssignView`: Asignar ingeniero (gestor)
- `WorkOrderListView`: Lista de OTs
- `MyWorkOrdersView`: Mis OTs asignadas (ingeniero)
- `WorkOrderLogCreateView`: Registrar avance (ingeniero)

---

### 3.4. App: `authentication/` - Autenticación y Roles

**Responsabilidad:** Autenticación, autorización y gestión de roles

```
authentication/
├── __init__.py
├── admin.py              # Admin de usuarios y grupos
├── apps.py
├── models.py             # Custom User model (si aplica) o extensiones
├── views.py              # Vistas de login, logout, perfil
├── urls.py               # URLs: /login/, /logout/, /profile/
├── forms.py              # Formularios de login, registro
├── permissions.py        # Permisos personalizados por rol
├── decorators.py         # Decoradores personalizados (@role_required)
├── utils.py              # Utilidades (verificar roles, permisos)
│
├── migrations/
│   └── ...
│
├── tests/
│   ├── test_views.py     # Tests de login, logout
│   ├── test_permissions.py
│   └── test_decorators.py
│
└── templates/
    └── authentication/
        ├── login.html
        ├── logout.html
        └── profile.html
```

**Modelos Principales:**
- Extiende `auth.User` nativo de Django
- Usa `auth.Group` para roles (analista, gestor, ingeniero)

**Vistas Principales:**
- `LoginView`: Login de usuarios
- `LogoutView`: Logout de usuarios
- `ProfileView`: Perfil de usuario

**Grupos (Roles):**
- `analista`: Puede validar reportes
- `gestor`: Puede crear OTs y asignar ingenieros
- `ingeniero`: Puede registrar avances
- `entidad_externa`: Solo lectura

---

### 3.5. App: `dashboard/` - Paneles Administrativos

**Responsabilidad:** Paneles administrativos y estadísticas

```
dashboard/
├── __init__.py
├── admin.py              # Admin de dashboard (opcional)
├── apps.py
├── views.py              # Vistas de dashboard (analista, gestor)
├── urls.py               # URLs: /dashboard/, /dashboard/analista/, etc.
├── utils.py              # Utilidades (estadísticas, agregaciones)
│
├── migrations/
│   └── (vacío, no tiene modelos)
│
├── tests/
│   └── test_views.py     # Tests de dashboards
│
└── templates/
    └── dashboard/
        ├── base.html     # Base del dashboard
        ├── analista.html # Dashboard de analista
        ├── gestor.html   # Dashboard de gestor
        └── statistics.html # Estadísticas
```

**Vistas Principales:**
- `AnalystDashboardView`: Dashboard de analista (reportes pendientes)
- `ManagerDashboardView`: Dashboard de gestor (reportes validados, mapa)
- `StatisticsView`: Estadísticas y métricas

---

### 3.6. App: `api/` - API REST (Opcional, Fase 3)

**Responsabilidad:** API REST para integraciones externas

```
api/
├── __init__.py
├── apps.py
├── views.py              # ViewSets de DRF
├── urls.py               # URLs de API: /api/reports/, etc.
├── serializers.py        # Serializers de DRF
├── permissions.py        # Permisos de API
├── pagination.py         # Paginación personalizada
│
├── migrations/
│   └── (vacío, no tiene modelos)
│
├── tests/
│   └── test_api.py       # Tests de API endpoints
│
└── (no templates, solo API)
```

**Endpoints Principales:**
- `/api/reports/`: Lista y detalle de reportes
- `/api/work-orders/`: Lista y detalle de OTs
- `/api/statistics/`: Estadísticas en formato JSON

---

### 3.7. App: `audit/` - Auditoría y Logs

**Responsabilidad:** Registro de acciones críticas y trazabilidad

```
audit/
├── __init__.py
├── admin.py              # Admin de AuditLog
├── apps.py
├── models.py             # AuditLog model
├── views.py              # Vistas de logs (list, search)
├── urls.py               # URLs: /audit/logs/
├── middleware.py         # Middleware para auditoría automática
├── utils.py              # Utilidades (crear log, formatear logs)
│
├── migrations/
│   └── ...
│
├── tests/
│   ├── test_models.py
│   └── test_middleware.py
│
└── templates/
    └── audit/
        └── log_list.html # Lista de logs de auditoría
```

**Modelos Principales:**
- `AuditLog`: Log de acciones críticas (login, validación, asignación, etc.)

**Funcionalidades:**
- Middleware para registrar acciones automáticamente
- Utilidades para crear logs manualmente
- Vistas para consultar logs de auditoría

---

## 4. Archivos de Configuración

### 4.1. `civisys/settings.py`

**Ubicación:** `civisys/settings/`

**Estructura recomendada:**
```
civisys/settings/
├── __init__.py           # Importa configuración según entorno
├── base.py               # Configuración base compartida
├── development.py        # Configuración desarrollo (DEBUG=True)
└── production.py        # Configuración producción (DEBUG=False)
```

**Configuración en `base.py`:**
- `INSTALLED_APPS`: Apps Django instaladas
- `MIDDLEWARE`: Middleware de Django
- `DATABASES`: Configuración de PostgreSQL+PostGIS
- `AUTHENTICATION_BACKENDS`: Backends de autenticación
- `STATIC_URL`, `STATIC_ROOT`: Archivos estáticos
- `MEDIA_URL`, `MEDIA_ROOT`: Archivos de media
- `TEMPLATES`: Configuración de templates
- `SECRET_KEY`: Desde variable de entorno
- `ALLOWED_HOSTS`: Hosts permitidos
- `TIME_ZONE`: Zona horaria (Colombia: America/Bogota)

**Configuración en `development.py`:**
- `DEBUG = True`
- `ALLOWED_HOSTS = ['localhost', '127.0.0.1']
- `EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'`

**Configuración en `production.py`:**
- `DEBUG = False`
- `ALLOWED_HOSTS`: Desde variable de entorno
- `SECURE_SSL_REDIRECT = True`
- `SESSION_COOKIE_SECURE = True`
- `CSRF_COOKIE_SECURE = True`
- `EMAIL_BACKEND`: SMTP configurado

### 4.2. `civisys/urls.py`

**URLs principales del proyecto:**

```python
urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('reports.urls')),
    path('work-orders/', include('work_orders.urls')),
    path('auth/', include('authentication.urls')),
    path('dashboard/', include('dashboard.urls')),
    path('api/', include('api.urls')),  # Opcional, Fase 3
    path('audit/', include('audit.urls')),
]
```

### 4.3. `requirements.txt`

**Dependencias Python:**

```txt
# Framework Principal
Django>=4.2,<5.0
djangorestframework>=3.14,<4.0  # Opcional, Fase 3
django-cors-headers>=4.0,<5.0

# Base de Datos
psycopg2-binary>=2.9,<3.0
# PostGIS se instala en PostgreSQL, no en Python

# Autenticación y Seguridad
argon2-cffi>=23.0,<24.0
django-ratelimit>=4.0,<5.0

# Utilidades
python-decouple>=3.8,<4.0  # Variables de entorno
Pillow>=10.0,<11.0  # Procesamiento de imágenes
reportlab>=4.0,<5.0  # Generación de PDFs

# Testing
pytest>=7.4,<8.0
pytest-django>=4.7,<5.0
pytest-cov>=4.1,<5.0
factory-boy>=3.3,<4.0  # Fixtures de prueba

# Development
ipython>=8.0,<9.0
django-debug-toolbar>=4.2,<5.0  # Solo desarrollo
```

### 4.4. `.env.example`

**Ejemplo de variables de entorno:**

```env
# Django
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Database
DB_NAME=civisys_db
DB_USER=civisys_user
DB_PASSWORD=your-db-password
DB_HOST=localhost
DB_PORT=5432

# PostGIS
POSTGIS_ENABLED=True

# Email (SMTP)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-email-password
DEFAULT_FROM_EMAIL=noreply@civisys.com

# Media Files
MEDIA_ROOT=/path/to/media
STATIC_ROOT=/path/to/static

# Security
CSRF_TRUSTED_ORIGINS=https://civisys.com
```

### 4.5. `.gitignore`

**Archivos ignorados por Git:**

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv

# Django
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal
/media
/staticfiles

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Testing
.pytest_cache/
.coverage
htmlcov/

# Documentation
*.pdf
*.docx
```

---

## 5. Templates y Static Files

### 5.1. Estructura de Templates

```
templates/
├── base.html             # Template base con Bootstrap
├── includes/
│   ├── header.html      # Header/navbar
│   ├── footer.html      # Footer
│   └── messages.html    # Mensajes flash
│
├── reports/
│   ├── create.html      # Formulario de reporte
│   ├── detail.html      # Detalle de reporte
│   ├── list.html        # Lista de reportes
│   └── status.html      # Consulta de estado
│
├── work_orders/
│   ├── create.html      # Crear OT
│   ├── list.html        # Lista de OTs
│   ├── detail.html      # Detalle de OT
│   ├── my_orders.html   # Mis OTs (ingeniero)
│   └── log_form.html    # Formulario de bitácora
│
├── authentication/
│   ├── login.html
│   └── profile.html
│
└── dashboard/
    ├── analista.html    # Dashboard de analista
    ├── gestor.html      # Dashboard de gestor
    └── statistics.html  # Estadísticas
```

### 5.2. Estructura de Static Files

```
static/
├── css/
│   ├── main.css         # Estilos principales
│   └── custom.css       # Estilos personalizados
│
├── js/
│   ├── main.js          # JavaScript principal
│   ├── maps.js          # Funcionalidad de mapas (Leaflet)
│   └── forms.js          # Validación de formularios
│
├── images/
│   ├── logo.png
│   └── icons/
│
└── vendor/
    ├── bootstrap/       # Bootstrap 5 (CDN o local)
    └── leaflet/         # Leaflet.js (CDN o local)
```

---

## 6. Media Files

### 6.1. Estructura de Media Files

```
media/
├── reports/
│   └── photos/
│       └── 2025/
│           └── 11/
│               └── report_12345_photo_001.jpg
│
└── work_orders/
    └── evidence/
        └── 2025/
            └── 11/
                └── ot_123_evidence_001.jpg
```

**Convenciones de Nombres:**
- Reportes: `report_{report_id}_photo_{sequence}.{ext}`
- Evidencia OT: `ot_{order_id}_evidence_{sequence}.{ext}`
- Organización por año/mes para facilitar gestión

**Límites:**
- Tamaño máximo: 5MB por archivo
- Formatos permitidos: JPG, PNG
- Validación: Client-side (HTML5) + Server-side (Django)

---

## 7. Tests

### 7.1. Estructura de Tests

```
tests/
├── __init__.py
├── conftest.py           # Configuración de pytest
├── factories.py          # Factories para tests (factory-boy)
│
├── test_reports.py       # Tests de módulo de reportes
├── test_work_orders.py   # Tests de módulo de OTs
├── test_authentication.py # Tests de autenticación
├── test_dashboard.py     # Tests de dashboards
├── test_api.py           # Tests de API (Fase 3)
└── test_audit.py         # Tests de auditoría
```

**Cobertura Objetivo:** > 80%

**Tipos de Tests:**
- **Unitarios:** Tests de modelos, formularios, utilidades
- **Integración:** Tests de vistas, flujos completos
- **E2E:** Tests end-to-end de flujos críticos (opcional)

---

## 8. Convenciones de Nombres

### 8.1. Nombres de Archivos Python

- **Archivos:** `snake_case` (ej: `incident_report.py`, `work_order_log.py`)
- **Clases:** `PascalCase` (ej: `IncidentReport`, `WorkOrderLog`)
- **Funciones:** `snake_case` (ej: `create_report`, `validate_location`)
- **Variables:** `snake_case` (ej: `report_id`, `user_email`)

### 8.2. Nombres de Archivos HTML/Templates

- **Templates:** `snake_case.html` (ej: `create_report.html`, `work_order_detail.html`)
- **Organización:** Por app en subdirectorio `app_name/`

### 8.3. Nombres de Archivos CSS/JS

- **CSS:** `snake_case.css` (ej: `main.css`, `custom_styles.css`)
- **JavaScript:** `snake_case.js` (ej: `main.js`, `map_utils.js`)

### 8.4. Nombres de Modelos

- **Modelos:** `PascalCase` (ej: `IncidentReport`, `WorkOrder`)
- **Tablas en BD:** Django genera automáticamente en `snake_case` (ej: `incident_report`)

### 8.5. Nombres de URLs

- **URLs:** `kebab-case` (ej: `/report/create`, `/work-orders/my-orders/`)
- **Slugs:** `kebab-case` (ej: `report-12345`, `work-order-456`)

---

## 9. Archivos de Entorno

### 9.1. `.env` (No versionado)

**Variables de entorno locales** - NO debe versionarse en Git

### 9.2. `.env.example` (Versionado)

**Ejemplo de variables de entorno** - Sí debe versionarse en Git

**Propósito:** Guía para otros desarrolladores sobre qué variables necesitan configurar

---

## 10. Scripts de Utilidad

### 10.1. `scripts/setup_db.py`

**Propósito:** Configurar base de datos inicial

```python
# Script para crear base de datos, extensiones PostGIS, etc.
```

### 10.2. `scripts/create_superuser.py`

**Propósito:** Crear superusuario inicial

```python
# Script para crear superusuario desde línea de comandos
```

### 10.3. `scripts/seed_data.py` (Opcional)

**Propósito:** Cargar datos de prueba para desarrollo

```python
# Script para crear datos de prueba (reportes, usuarios, etc.)
```

---

## 11. Comandos Django Comunes

### 11.1. Setup Inicial

```bash
# Crear entorno virtual
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate    # Windows

# Instalar dependencias
pip install -r requirements.txt

# Configurar base de datos
python manage.py migrate

# Crear superusuario
python manage.py createsuperuser

# Recopilar archivos estáticos
python manage.py collectstatic
```

### 11.2. Desarrollo

```bash
# Ejecutar servidor de desarrollo
python manage.py runserver

# Crear migraciones
python manage.py makemigrations

# Aplicar migraciones
python manage.py migrate

# Ejecutar tests
pytest
# o
python manage.py test
```

### 11.3. Producción

```bash
# Recopilar archivos estáticos
python manage.py collectstatic --noinput

# Aplicar migraciones
python manage.py migrate --noinput

# Verificar configuración
python manage.py check --deploy
```

---

## 12. Referencias

- **Documentación del Proyecto:** `/README.md`
- **Arquitectura del Sistema:** `/ARCHITECTURE.md`
- **Plan de Proyecto:** `/PROJECT_PLAN.md`
- **Guía para Agentes:** `/agents.md`
- **Django Best Practices:** https://docs.djangoproject.com/en/stable/
- **Django GIS:** https://docs.djangoproject.com/en/stable/ref/contrib/gis/

---

**Última actualización:** 2025-11-04  
**Mantenido por:** Equipo de Desarrollo Civisys

