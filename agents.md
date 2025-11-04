# 🛡️ agents.md - Guía para Agentes de Código y Arquitectura

Este documento establece las reglas y el contexto obligatorio que deben seguir todos los Agentes de IA y desarrolladores que interactúen con este repositorio.

## 1. 🎯 Misión del Proyecto y Contexto

**Objetivo Principal**: Centralizar, estandarizar y dar trazabilidad completa al ciclo de gestión de incidentes de derrumbe (Reporte $\rightarrow$ Validación $\rightarrow$ Asignación $\rightarrow$ Seguimiento $\rightarrow$ Cierre) en corredores viales.

**Restricción Crítica**: El proyecto debe usar herramientas de costo cero de licencia (Gratuitas y Open Source).

**Usuarios Clave**: Gestor Local (Admin), Analista, Ingeniero Residente, Ciudadano.

## 2. 💻 Stack Tecnológico (Fuente de Verdad)

Los agentes deben utilizar estrictamente este stack. No se permite el uso de librerías o servicios con costos de licencia o uso.

| Componente | Tecnología | Notas Importantes |
|------------|------------|-------------------|
| Backend / Lógica | Python 3.x / Django 4+ | Usar las convenciones estándar de Django (Models, Views, URLs). |
| Base de Datos / GIS | PostgreSQL con extensión PostGIS | Obligatorio el uso de django.contrib.gis.db.models para campos geográficos. |
| Frontend / UI | HTML, CSS, JavaScript / Bootstrap 5 | Interfaz debe ser simple y usable en baja conectividad (mobile-first). |
| Mapas / GIS | Leaflet.js / OpenStreetMap (OSM) | Soluciones client-side gratuitas para visualización de mapas. |

## 3. 🛡️ Estándares de Codificación y Seguridad (Mandatorios)

El código generado debe adherirse a estas reglas sin excepción.

### A. Seguridad por Diseño (Security by Design)

- **Autenticación**: Utilizar el sistema de autenticación nativo de Django. Las contraseñas deben ser hasheadas usando los algoritmos más robustos disponibles en el framework (preferentemente Argon2 o BCrypt).
- **Autorización (Broken Access Control)**: Implementar una capa de permisos estricta basada en roles (Analista, Gestor, Ingeniero) utilizando el sistema de permisos de Django. Nunca exponer funciones administrativas (crear OT, validar) a usuarios que no estén autenticados y autorizados.
- **Credenciales**: PROHIBIDO incluir claves de API, credenciales de correo electrónico o secretos directamente en el código fuente (Hardcoding). Usar variables de entorno (.env) para toda información sensible.
- **Auditoría / Trazabilidad**: Toda acción crítica (Validar, Asignar, Cerrar) debe generar un Log de Auditoría (usuario, acción, timestamp).

### B. Calidad y Estilo (PEP 8)

- **Convención de Nombres**: Usar snake_case (ejemplo_de_funcion) para todas las variables, funciones y nombres de archivos Python, siguiendo el estándar PEP 8.
- **Documentación**: Toda función, clase o método nuevo debe incluir un docstring descriptivo (preferiblemente con formato Google Style o reStructuredText) que describa la entrada, la salida y la lógica.

## 4. 📝 Flujo de Desarrollo (Test-Driven Development - TDD)

Todo el trabajo debe seguir el ciclo TDD.

1. **Tests Primero (Red)**: Antes de escribir cualquier código de implementación, el agente debe escribir los tests unitarios correspondientes en el directorio /tests. Estos tests deben fallar inicialmente.
2. **Fuente de Tests**: Los tests unitarios deben basarse directamente en los Criterios de Aceptación Gherkin definidos en la Documentación Inicial del Proyecto.
3. **Implementación (Green)**: Solo después de que los tests estén escritos y fallando, se implementará el código necesario para hacer que las pruebas pasen.

## 5. 🗃️ Fuentes de Verdad (Contexto Estructural)

Los agentes deben referenciarse a estos archivos para obtener el contexto estructural.

- **Esquema de Base de Datos**: La estructura de las tablas, incluyendo los campos PostGIS, se define exclusivamente en el archivo:
  `/context/database.sql`
- **Modelos de Django**: Los agentes deben generar los models.py asegurándose de que reflejen exactamente la estructura definida en database.sql.