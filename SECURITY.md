# 🔒 SECURITY.md - Políticas de Seguridad del Sistema Civisys

**Versión:** 1.0  
**Fecha:** 2025-11-04  
**Autor:** Equipo Civisys

---

## 📋 Índice

1. [Introducción](#1-introducción)
2. [Principios de Seguridad](#2-principios-de-seguridad)
3. [OWASP Top 10 (2021) - Medidas de Mitigación](#3-owasp-top-10-2021---medidas-de-mitigación)
4. [Autenticación y Autorización](#4-autenticación-y-autorización)
5. [Gestión de Credenciales](#5-gestión-de-credenciales)
6. [Protección de Datos](#6-protección-de-datos)
7. [Seguridad de la Aplicación](#7-seguridad-de-la-aplicación)
8. [Seguridad de la Base de Datos](#8-seguridad-de-la-base-de-datos)
9. [Seguridad de la Infraestructura](#9-seguridad-de-la-infraestructura)
10. [Auditoría y Logging](#10-auditoría-y-logging)
11. [Manejo de Incidentes](#11-manejo-de-incidentes)
12. [Checklist de Seguridad](#12-checklist-de-seguridad)

---

## 1. Introducción

Este documento establece las **políticas de seguridad** del Sistema Civisys, basadas en las mejores prácticas de la industria y el **OWASP Top 10 (2021)**.

**Objetivo:** Garantizar la confidencialidad, integridad y disponibilidad de los datos del sistema, así como proteger a los usuarios y sus información.

**Alcance:** Aplica a todo el desarrollo, despliegue y operación del sistema.

---

## 2. Principios de Seguridad

### 2.1. Security by Design

**Principio:** La seguridad debe implementarse desde el diseño, no como una medida posterior.

**Aplicación:**
- Revisión de seguridad en cada fase del desarrollo
- Implementación de controles de seguridad desde el inicio
- Validación de seguridad en cada feature

### 2.2. Defense in Depth

**Principio:** Múltiples capas de seguridad para proteger el sistema.

**Aplicación:**
- Firewall a nivel de servidor
- Autenticación y autorización en la aplicación
- Validación de entrada en múltiples capas
- Cifrado de datos sensibles

### 2.3. Least Privilege

**Principio:** Otorgar solo los permisos mínimos necesarios.

**Aplicación:**
- Roles de usuario con permisos específicos
- Separación de permisos por funcionalidad
- Revisión periódica de permisos

### 2.4. Fail Secure

**Principio:** En caso de error, el sistema debe fallar de forma segura.

**Aplicación:**
- Bloquear acceso en caso de error de autenticación
- No exponer información sensible en mensajes de error
- Logs de errores sin información sensible

---

## 3. OWASP Top 10 (2021) - Medidas de Mitigación

### 3.1. A01:2021 – Broken Access Control

**Descripción:** Vulnerabilidades que permiten a usuarios acceder a funcionalidades o datos sin autorización.

**Medidas de Mitigación:**

1. **Control de Acceso Basado en Roles (RBAC)**
   - Implementar roles estrictos: `analista`, `gestor`, `ingeniero`, `entidad_externa`
   - Usar decoradores Django: `@login_required`, `@permission_required`
   - Verificar permisos en cada vista antes de procesar

2. **Validación de Permisos**
   ```python
   # Ejemplo: Verificar que el usuario tiene permiso antes de acceder
   @login_required
   @permission_required('reports.can_validate', raise_exception=True)
   def validate_report(request, report_id):
       # Solo usuarios con rol 'analista' pueden acceder
       if not request.user.groups.filter(name='analista').exists():
           raise PermissionDenied
       # ... lógica de validación
   ```

3. **Validación de Propiedad de Recursos**
   - Verificar que el usuario solo puede acceder a sus propios recursos
   - Ejemplo: Ingeniero solo puede ver OTs asignadas a él

4. **Rate Limiting**
   - Implementar `django-ratelimit` para prevenir ataques de fuerza bruta
   - Limitar intentos de login por IP
   - Limitar requests por usuario

**Código de Ejemplo:**
```python
from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django_ratelimit.decorators import ratelimit

@ratelimit(key='ip', rate='5/m', method='POST')
@login_required
def validate_report(request, report_id):
    # Verificar rol
    if not request.user.groups.filter(name='analista').exists():
        raise PermissionDenied("Solo analistas pueden validar reportes")
    
    # Verificar que el reporte existe y está disponible
    report = get_object_or_404(IncidentReport, id=report_id, status='recibido')
    
    # ... lógica de validación
```

---

### 3.2. A02:2021 – Cryptographic Failures

**Descripción:** Exposición de datos sensibles debido a cifrado débil o falta de cifrado.

**Medidas de Mitigación:**

1. **Hashing de Contraseñas**
   - Usar **Argon2** (recomendado) o **PBKDF2** para hashing de contraseñas
   - Configurar en `settings.py`:
   ```python
   PASSWORD_HASHERS = [
       'django.contrib.auth.hashers.Argon2PasswordHasher',
       'django.contrib.auth.hashers.PBKDF2PasswordHasher',
   ]
   ```

2. **HTTPS Obligatorio en Producción**
   - Configurar SSL/TLS con Let's Encrypt
   - Forzar redirección HTTPS:
   ```python
   # settings/production.py
   SECURE_SSL_REDIRECT = True
   SESSION_COOKIE_SECURE = True
   CSRF_COOKIE_SECURE = True
   ```

3. **Cifrado de Datos Sensibles**
   - No almacenar contraseñas en texto plano
   - Cifrar datos sensibles en base de datos (opcional, para datos muy sensibles)
   - No exponer datos sensibles en logs

4. **Variables de Entorno**
   - Usar `.env` para credenciales y secretos
   - No hardcodear claves en el código
   - Rotar secretos regularmente

---

### 3.3. A03:2021 – Injection

**Descripción:** Vulnerabilidades que permiten inyectar código malicioso (SQL, XSS, etc.).

**Medidas de Mitigación:**

1. **Protección contra SQL Injection**
   - Usar **Django ORM** exclusivamente (no SQL crudo)
   - El ORM de Django escapa automáticamente las consultas
   - Si es necesario usar SQL crudo, usar parámetros:
   ```python
   # ❌ NUNCA hacer esto:
   query = "SELECT * FROM reports WHERE id = " + user_input
   
   # ✅ Siempre usar parámetros:
   Report.objects.filter(id=user_input)
   # O si es necesario SQL crudo:
   cursor.execute("SELECT * FROM reports WHERE id = %s", [user_input])
   ```

2. **Protección contra XSS (Cross-Site Scripting)**
   - Django escapa automáticamente en templates
   - No usar `|safe` a menos que sea absolutamente necesario
   - Validar y sanitizar entrada de usuario
   ```django
   {# ✅ Django escapa automáticamente #}
   <p>{{ report.description }}</p>
   
   {# ❌ Solo si confías 100% en el contenido #}
   <p>{{ report.description|safe }}</p>
   ```

3. **Protección contra Command Injection**
   - No ejecutar comandos del sistema con entrada de usuario
   - Si es necesario, usar `subprocess` con parámetros validados

4. **Validación de Entrada**
   - Validar y sanitizar toda entrada de usuario
   - Usar Django Forms con validación
   - Validar tipos de datos, rangos, formatos

---

### 3.4. A04:2021 – Insecure Design

**Descripción:** Vulnerabilidades de diseño que no consideran seguridad desde el inicio.

**Medidas de Mitigación:**

1. **Revisión de Diseño de Seguridad**
   - Revisar diseño de nuevas features desde perspectiva de seguridad
   - Documentar decisiones de seguridad
   - Considerar casos edge y ataques potenciales

2. **Threat Modeling**
   - Identificar amenazas potenciales en cada feature
   - Documentar medidas de mitigación
   - Actualizar threat model periódicamente

3. **Principios de Diseño Seguro**
   - Security by Design en todas las decisiones
   - Fail Secure en caso de errores
   - Least Privilege en permisos

---

### 3.5. A05:2021 – Security Misconfiguration

**Descripción:** Configuración incorrecta o por defecto del sistema, frameworks o servidores.

**Medidas de Mitigación:**

1. **Configuración de Django**
   ```python
   # settings/production.py
   DEBUG = False  # NUNCA True en producción
   ALLOWED_HOSTS = ['civisys.com']  # Especificar hosts permitidos
   SECRET_KEY = os.getenv('SECRET_KEY')  # Desde variable de entorno
   ```

2. **Headers de Seguridad**
   ```python
   # settings/production.py
   SECURE_BROWSER_XSS_FILTER = True
   SECURE_CONTENT_TYPE_NOSNIFF = True
   X_FRAME_OPTIONS = 'DENY'  # Prevenir clickjacking
   SECURE_HSTS_SECONDS = 31536000
   SECURE_HSTS_INCLUDE_SUBDOMAINS = True
   SECURE_HSTS_PRELOAD = True
   ```

3. **Configuración del Servidor Web**
   - Configurar Nginx/Apache con headers de seguridad
   - Deshabilitar información del servidor
   - Configurar límites de tamaño de request

4. **Base de Datos**
   - No usar usuario `postgres` con permisos de superusuario
   - Crear usuario específico con permisos mínimos
   - Configurar contraseñas fuertes

5. **Checklist de Configuración**
   - [ ] DEBUG = False en producción
   - [ ] ALLOWED_HOSTS configurado
   - [ ] SECRET_KEY en variable de entorno
   - [ ] SSL/TLS configurado
   - [ ] Headers de seguridad configurados
   - [ ] Usuario de BD con permisos mínimos

---

### 3.6. A06:2021 – Vulnerable and Outdated Components

**Descripción:** Uso de componentes vulnerables o desactualizados.

**Medidas de Mitigación:**

1. **Gestión de Dependencias**
   - Usar `requirements.txt` con versiones específicas
   - Revisar vulnerabilidades regularmente
   - Actualizar dependencias con seguridad en mente

2. **Monitoreo de Vulnerabilidades**
   - Usar `safety` para detectar vulnerabilidades:
   ```bash
   pip install safety
   safety check -r requirements.txt
   ```
   - Revisar CVE (Common Vulnerabilities and Exposures)
   - Suscribirse a alertas de seguridad de Django

3. **Actualizaciones Regulares**
   - Actualizar Django y dependencias regularmente
   - Probar actualizaciones en ambiente de staging
   - Documentar cambios y actualizaciones

4. **Dependencias Mínimas**
   - Solo incluir dependencias necesarias
   - Revisar dependencias transitivas
   - Eliminar dependencias no utilizadas

---

### 3.7. A07:2021 – Identification and Authentication Failures

**Descripción:** Vulnerabilidades en autenticación y gestión de sesiones.

**Medidas de Mitigación:**

1. **Autenticación Robusta**
   - Usar sistema de autenticación nativo de Django
   - Hashing fuerte de contraseñas (Argon2)
   - Validación de contraseñas fuertes (opcional)

2. **Protección contra Fuerza Bruta**
   ```python
   from django_ratelimit.decorators import ratelimit
   
   @ratelimit(key='ip', rate='5/m', method='POST')
   def login_view(request):
       # Limitar intentos de login por IP
       # ... lógica de login
   ```

3. **Gestión de Sesiones Segura**
   ```python
   # settings/production.py
   SESSION_COOKIE_SECURE = True  # Solo HTTPS
   SESSION_COOKIE_HTTPONLY = True  # No accesible por JavaScript
   SESSION_COOKIE_SAMESITE = 'Strict'  # Prevenir CSRF
   SESSION_EXPIRE_AT_BROWSER_CLOSE = True  # Cerrar al cerrar navegador
   ```

4. **Multi-Factor Authentication (Opcional, Futuro)**
   - Considerar implementar 2FA para usuarios críticos
   - Usar bibliotecas como `django-otp` (opcional)

5. **Logout Seguro**
   - Invalidar sesión al hacer logout
   - Limpiar cookies de sesión
   - Redirigir a página segura

---

### 3.8. A08:2021 – Software and Data Integrity Failures

**Descripción:** Vulnerabilidades en integridad de software y datos (CI/CD inseguro, dependencias comprometidas).

**Medidas de Mitigación:**

1. **CI/CD Seguro**
   - No almacenar secretos en repositorios
   - Usar variables de entorno en CI/CD
   - Firmar commits (opcional)

2. **Validación de Integridad**
   - Verificar checksums de dependencias
   - Usar `pip` con `--require-hashes` (opcional)
   - Validar integridad de archivos subidos

3. **Backups Seguros**
   - Cifrar backups
   - Validar integridad de backups
   - Almacenar backups en ubicación segura

4. **Control de Versiones**
   - Usar Git para control de versiones
   - Revisar cambios antes de merge
   - No exponer información sensible en commits

---

### 3.9. A09:2021 – Security Logging and Monitoring Failures

**Descripción:** Falta de logging y monitoreo de seguridad adecuado.

**Medidas de Mitigación:**

1. **Logging de Seguridad**
   ```python
   import logging
   
   security_logger = logging.getLogger('security')
   
   def log_security_event(event_type, user, details):
       security_logger.warning(
           f"Security Event: {event_type} | User: {user} | Details: {details}"
       )
   
   # Ejemplo: Log de intentos de login fallidos
   if not user:
       log_security_event('FAILED_LOGIN', username, {'ip': request.META.get('REMOTE_ADDR')})
   ```

2. **Auditoría de Acciones Críticas**
   - Registrar todas las acciones críticas (validar, asignar, cerrar)
   - Incluir: usuario, acción, timestamp, IP
   - Almacenar en tabla `audit_log`

3. **Monitoreo de Eventos**
   - Monitorear intentos de login fallidos
   - Alertar sobre patrones sospechosos
   - Revisar logs regularmente

4. **Retención de Logs**
   - Conservar logs por tiempo determinado (ej: 90 días)
   - Rotar logs para evitar llenar disco
   - Archivar logs antiguos

---

### 3.10. A10:2021 – Server-Side Request Forgery (SSRF)

**Descripción:** Vulnerabilidades que permiten hacer requests a recursos internos.

**Medidas de Mitigación:**

1. **Validación de URLs**
   - Validar URLs de entrada antes de hacer requests
   - Bloquear URLs internas (localhost, 127.0.0.1, etc.)
   - Usar whitelist de dominios permitidos

2. **Límites de Red**
   - Configurar firewall para bloquear acceso interno
   - Usar listas negras de IPs internas
   - Validar destino de requests salientes

3. **No Hacer Requests a URLs de Usuario**
   - Evitar hacer requests HTTP a URLs proporcionadas por usuarios
   - Si es necesario, validar y sanitizar URLs

---

## 4. Autenticación y Autorización

### 4.1. Autenticación

**Sistema de Autenticación:**
- Usar sistema nativo de Django (`django.contrib.auth`)
- Hashing de contraseñas con **Argon2** (recomendado)
- Validación de contraseñas (opcional, futuro)

**Configuración:**
```python
# settings.py
PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.Argon2PasswordHasher',
    'django.contrib.auth.hashers.PBKDF2PasswordHasher',
    'django.contrib.auth.hashers.PBKDF2SHA1PasswordHasher',
]

# Validación de contraseñas (opcional)
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator', 'OPTIONS': {'min_length': 8}},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]
```

**Protección contra Fuerza Bruta:**
```python
from django_ratelimit.decorators import ratelimit

@ratelimit(key='ip', rate='5/m', method='POST')
def login_view(request):
    # Máximo 5 intentos por minuto por IP
    # ... lógica de login
```

### 4.2. Autorización

**Sistema de Roles:**
- Usar **Django Groups** para roles
- Roles: `analista`, `gestor`, `ingeniero`, `entidad_externa`

**Implementación:**
```python
from django.contrib.auth.decorators import login_required, permission_required
from django.core.exceptions import PermissionDenied

@login_required
def validate_report(request, report_id):
    # Verificar rol
    if not request.user.groups.filter(name='analista').exists():
        raise PermissionDenied("Solo analistas pueden validar reportes")
    
    # ... lógica de validación
```

**Permisos por Funcionalidad:**

| Rol | Permisos |
|-----|----------|
| **Analista** | Validar reportes, descartar reportes, ver dashboard analista |
| **Gestor** | Crear OTs, asignar ingenieros, ver dashboard gestor, exportar datos |
| **Ingeniero** | Ver OTs asignadas, registrar avances, ver historial |
| **Entidad Externa** | Solo lectura, exportar datos |

---

## 5. Gestión de Credenciales

### 5.1. Variables de Entorno

**Principio:** NUNCA hardcodear credenciales en el código.

**Implementación:**
```python
# settings.py
from decouple import config

SECRET_KEY = config('SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)
ALLOWED_HOSTS = config('ALLOWED_HOSTS', default='').split(',')

# Base de datos
DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': config('DB_NAME'),
        'USER': config('DB_USER'),
        'PASSWORD': config('DB_PASSWORD'),
        'HOST': config('DB_HOST', default='localhost'),
        'PORT': config('DB_PORT', default='5432'),
    }
}

# Email
EMAIL_HOST = config('EMAIL_HOST')
EMAIL_PORT = config('EMAIL_PORT', default=587, cast=int)
EMAIL_HOST_USER = config('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = config('EMAIL_HOST_PASSWORD')
```

**Archivo `.env.example`:**
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

# Email
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-email-password
```

### 5.2. Rotación de Secretos

**Prácticas:**
- Rotar `SECRET_KEY` periódicamente (anualmente o cuando se sospeche compromiso)
- Rotar contraseñas de base de datos cada 90 días
- Rotar credenciales de email cuando sea necesario

**Proceso de Rotación:**
1. Generar nuevo secreto
2. Actualizar variable de entorno
3. Reiniciar aplicación
4. Invalidar sesiones existentes (opcional)

---

## 6. Protección de Datos

### 6.1. Datos Sensibles

**Datos que NO deben exponerse:**
- Contraseñas (hasheadas, nunca en texto plano)
- Tokens de sesión
- Credenciales de base de datos
- Claves de API

**Protección:**
- No registrar datos sensibles en logs
- No incluir datos sensibles en mensajes de error
- Sanitizar datos antes de mostrar en frontend

### 6.2. Cifrado de Datos

**En Tránsito:**
- HTTPS obligatorio en producción
- TLS 1.2 o superior
- Certificado SSL válido (Let's Encrypt)

**En Reposo:**
- Contraseñas hasheadas (Argon2)
- Backup cifrados (opcional)
- Datos sensibles en BD cifrados (opcional, para datos muy sensibles)

---

## 7. Seguridad de la Aplicación

### 7.1. Validación de Entrada

**Principio:** Validar y sanitizar toda entrada de usuario.

**Implementación:**
```python
from django import forms
from django.core.exceptions import ValidationError

class IncidentReportForm(forms.ModelForm):
    class Meta:
        model = IncidentReport
        fields = ['description', 'location', 'photo']
    
    def clean_description(self):
        description = self.cleaned_data.get('description')
        if len(description) < 10:
            raise ValidationError("La descripción debe tener al menos 10 caracteres")
        return description
```

### 7.2. Protección CSRF

**Django protege automáticamente contra CSRF:**
```django
{% csrf_token %}
```

**Configuración:**
```python
# settings.py
CSRF_COOKIE_SECURE = True  # Solo HTTPS
CSRF_COOKIE_HTTPONLY = True
CSRF_COOKIE_SAMESITE = 'Strict'
```

### 7.3. Headers de Seguridad

**Configuración:**
```python
# settings/production.py
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'  # Prevenir clickjacking
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

# Content Security Policy (opcional)
CSP_DEFAULT_SRC = "'self'"
CSP_SCRIPT_SRC = "'self' 'unsafe-inline'"  # Para Leaflet.js
CSP_STYLE_SRC = "'self' 'unsafe-inline'"
```

---

## 8. Seguridad de la Base de Datos

### 8.1. Usuario de Base de Datos

**Mejores Prácticas:**
- Crear usuario específico para la aplicación (no usar `postgres`)
- Otorgar solo permisos necesarios (no superusuario)
- Contraseña fuerte y única

**Configuración SQL:**
```sql
-- Crear usuario específico
CREATE USER civisys_user WITH PASSWORD 'strong_password_here';

-- Otorgar permisos necesarios
GRANT CONNECT ON DATABASE civisys_db TO civisys_user;
GRANT USAGE ON SCHEMA public TO civisys_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO civisys_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO civisys_user;
```

### 8.2. Protección contra SQL Injection

**Principio:** Usar Django ORM exclusivamente.

**Ejemplo:**
```python
# ✅ Correcto: Usar ORM
reports = IncidentReport.objects.filter(status='recibido')

# ❌ Incorrecto: SQL crudo (solo si es absolutamente necesario)
from django.db import connection
cursor = connection.cursor()
cursor.execute("SELECT * FROM incident_report WHERE status = %s", ['recibido'])
```

### 8.3. Backup y Recuperación

**Prácticas:**
- Backups diarios automáticos
- Cifrar backups
- Almacenar backups en ubicación remota
- Probar restauración regularmente

---

## 9. Seguridad de la Infraestructura

### 9.1. Servidor Web

**Configuración Nginx:**
```nginx
# Headers de seguridad
add_header X-Frame-Options "DENY" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

# Ocultar información del servidor
server_tokens off;

# Límites
client_max_body_size 10M;
```

### 9.2. Firewall

**Configuración:**
- Permitir solo puertos necesarios (80, 443, 22)
- Bloquear acceso a puertos internos
- Configurar rate limiting

### 9.3. SSL/TLS

**Configuración:**
- Usar Let's Encrypt para certificados gratuitos
- Renovar certificados automáticamente
- Forzar HTTPS en producción

---

## 10. Auditoría y Logging

### 10.1. Logging de Seguridad

**Eventos a Registrar:**
- Intentos de login (exitosos y fallidos)
- Cambios de permisos
- Acciones críticas (validar, asignar, cerrar)
- Accesos a recursos sensibles
- Errores de seguridad

**Implementación:**
```python
import logging

security_logger = logging.getLogger('security')

def log_security_event(event_type, user, details):
    security_logger.warning(
        f"Security Event: {event_type} | "
        f"User: {user} | "
        f"IP: {details.get('ip')} | "
        f"Details: {details}"
    )

# Ejemplo: Log de validación de reporte
log_security_event(
    'REPORT_VALIDATED',
    request.user.username,
    {'report_id': report_id, 'severity': severity, 'ip': request.META.get('REMOTE_ADDR')}
)
```

### 10.2. Auditoría de Acciones Críticas

**Implementación:**
```python
from audit.models import AuditLog

def create_audit_log(user, action, resource_type, resource_id, details=None):
    AuditLog.objects.create(
        user=user,
        action=action,
        resource_type=resource_type,
        resource_id=resource_id,
        details=details or {},
        ip_address=request.META.get('REMOTE_ADDR'),
        user_agent=request.META.get('HTTP_USER_AGENT'),
    )
```

---

## 11. Manejo de Incidentes

### 11.1. Procedimiento de Respuesta

**Pasos:**
1. **Identificación:** Detectar el incidente
2. **Contención:** Limitar el impacto
3. **Eradicación:** Eliminar la causa
4. **Recuperación:** Restaurar servicios
5. **Lecciones Aprendidas:** Documentar y mejorar

### 11.2. Contactos de Emergencia

- **Equipo de Desarrollo:** [contacto]
- **DevOps:** [contacto]
- **Seguridad:** [contacto]

---

## 12. Checklist de Seguridad

### 12.1. Pre-Despliegue

- [ ] DEBUG = False en producción
- [ ] ALLOWED_HOSTS configurado
- [ ] SECRET_KEY en variable de entorno
- [ ] SSL/TLS configurado
- [ ] Headers de seguridad configurados
- [ ] Usuario de BD con permisos mínimos
- [ ] Firewall configurado
- [ ] Backups configurados
- [ ] Logging configurado
- [ ] Rate limiting configurado

### 12.2. Revisión de Código

- [ ] No hay credenciales hardcodeadas
- [ ] Validación de entrada implementada
- [ ] Control de acceso implementado
- [ ] Protección CSRF implementada
- [ ] Logging de acciones críticas
- [ ] Manejo seguro de errores
- [ ] No exposición de información sensible

### 12.3. Post-Despliegue

- [ ] Monitoreo configurado
- [ ] Alertas configuradas
- [ ] Revisión de logs regular
- [ ] Actualización de dependencias
- [ ] Revisión de permisos periódica

---

## 13. Referencias

- **OWASP Top 10 (2021):** https://owasp.org/www-project-top-ten/
- **Django Security:** https://docs.djangoproject.com/en/stable/topics/security/
- **Documentación del Proyecto:** `/README.md`
- **Guía para Agentes:** `/agents.md`
- **Análisis de Riesgos:** `/RISK_ANALYSIS.md`

---

**Última actualización:** 2025-11-04  
**Mantenido por:** Equipo de Desarrollo Civisys  
**Próxima Revisión:** Trimestral o cuando se detecte vulnerabilidad

