# civisys
Sistema de Información Civil

Feature: Contexto y Problema Central — Plataforma de Gestión y Seguimiento de Riesgos por Derrumbes



Background:

Given Zonas críticas de derrumbe en corredores viales de Colombia con relieve pronunciado, suelos saturables y lluvias intensificadas

And Comunicación y gestión de incidentes actualmente fragmentada entre ciudadanos, alcaldías y equipos técnicos

And Recursos financieros limitados que obligan a utilizar únicamente herramientas gratuitas y de bajo costo operacional



# ---------- 1) Problema específico que busca resolver ----------

Scenario: Problema central — falta de un sistema único y trazable para reportes y seguimiento

Given Que ocurren eventos de derrumbe, bloqueo o inestabilidad en tramos viales críticos

And Que los reportes se reciben por canales dispersos (llamadas telefónicas, redes sociales, notas en alcaldías) sin estandarización

And Que no existe un registro único con evidencia, historial y estado de avance de obras de mitigación

When Un ciudadano informa un incidente o una autoridad detecta un evento

Then La información no siempre llega de forma oportuna a los responsables técnicos

And No hay priorización basada en severidad ni trazabilidad completa del ciclo de gestión

And Las decisiones de mitigación se retrasan o se duplican por falta de datos consolidados

So El problema que se debe resolver es: centralizar, estandarizar y dar trazabilidad (registro — validación — priorización — asignación — seguimiento — cierre) a los incidentes y obras de mitigación usando únicamente herramientas gratuitas



# ---------- 2) Usuario(s) principal(es) y valor central ----------

Scenario: Usuario principal — Alcaldía / Gestor local (rol gestor)

Given El Gestor local (por ejemplo, Alcaldía) necesita supervisar seguridad vial y coordinar recursos de mitigación

When El Gestor accede a la plataforma

Then Obtiene un panel consolidado con reportes validados, filtros por severidad y fecha

And Puede asignar responsables, generar órdenes de trabajo y descargar reportes en PDF/CSV

And Recibe notificaciones básicas (correo) sobre eventos críticos

So El valor central para el Gestor es: visibilidad inmediata y control operativo sobre incidentes y obras sin depender de procesos manuales ni canales dispersos



Scenario: Usuario principal — Ingeniero Residente / Coordinador técnico

Given El Ingeniero Residente debe planear y ejecutar obras de mitigación y reportar avance técnico

When El Ingeniero recibe una asignación desde la plataforma

Then Puede registrar verificación de campo, adjuntar fotos y bitácoras, actualizar estado de la obra y registrar costos estimados

And El sistema conserva historial inmutable de cambios y evidencias

So El valor central para el Ingeniero es: una herramienta de registro y seguimiento técnico que facilita rendición de cuentas y continuidad operativa



Scenario: Usuario principal — Ciudadano / Usuario final

Given Los ciudadanos transitan por vías de riesgo y observan incidentes o condiciones peligrosas

When Un ciudadano reporta desde la web o formulario móvil (sin autenticarse o con autenticación básica)

Then El sistema valida la entrada mínima (ubicación, descripción, foto opcional), guarda el reporte y retorna un acuse de recibo al remitente

And El reporte queda disponible para revisión por personal autorizado y en cola de priorización

So El valor central para el ciudadano es: participación efectiva y trazabilidad básica (saber que su alerta fue recibida y está siendo gestionada)



Scenario: Usuario secundario — Analista / Operador de plataforma

Given El Analista es responsable de validar, clasificar y priorizar reportes

When El Analista procesa un nuevo reporte

Then Puede aplicar criterios de severidad (alto/medio/bajo), añadir observaciones y asignar prioridad y responsable

And El sistema registra tiempos (hora de recepción, hora de validación, hora de asignación)

So El valor central para el Analista es: herramientas de trabajo con registros históricos y métricas para medir tiempos de respuesta



Scenario: Usuario secundario — Entidades técnicas externas (p. ej. INVÍAS, ANI) con acceso restringido

Given Estas entidades requieren información resumida y comprobable para tomar decisiones interinstitucionales

When Se solicita un reporte consolidado o evidencia técnica

Then La plataforma permite exportar datos filtrados y enviar reportes en formatos estándar (CSV, PDF)

So El valor central para estas entidades es: acceso a datos homogéneos que facilitan coordinación interinstitucional



# ---------- 3) Criterios de aceptación funcionales (qué debe hacer la aplicación) ----------

Scenario Outline: Criterios de aceptación por rol y función

Given Un <Rol> realiza la acción <Accion>

When La acción se ejecuta en la plataforma

Then El sistema debe <Resultado esperado>



Examples:

| Rol | Accion | Resultado esperado |

| Ciudadano | Reportar un derrumbe | Guardar reporte con ID, fecha, ubicación y acuse al remitente |

| Analista | Validar y clasificar el reporte | Cambiar estado a "validado" y asignar severidad; registrar timestamp |

| Gestor local | Asignar un ingeniero a una orden | Crear orden de trabajo vinculada al incidente y notificar responsable |

| Ingeniero Residente | Subir evidencia y actualizar avance | Registrar fotos, bitácora y % de avance; historial no debe perderse |

| Gestor local / Admin | Exportar reportes a PDF/CSV | Generar fichero con filtros aplicados y descargarlo |

# ---------- 4) Restricciones y condiciones no funcionales (implican el alcance) ----------


Scenario: Restricciones operativas y tecnológicas

Given No existen recursos financieros para licencias comerciales

And El despliegue debe ser reproducible con herramientas gratuitas

When Se implementa la solución

Then Debe usar tecnologías de bajo costo: base de datos ligera (SQLite), servidor web gratuito o autoalojado, control de versiones en GitHub, SSL gratuito (Let's Encrypt) y notificaciones por correo SMTP o servicios gratuitos

And La interfaz debe ser usable en dispositivos de baja conectividad y con UX simple para ciudadanos

And La plataforma debe registrar auditoría básica (usuario, acción, timestamp) para trazabilidad

# ---------- 4) Stack tecnologico ----------

Componente,Opción Seleccionada,Justificación (Restricción de Cero Costo)
Backend,Python / Django,"Robustez, ORM potente, Admin integrado, gran ecosistema."
Base de Datos,PostgreSQL + PostGIS,Estándar profesional para datos geográficos (GIS). Licencia gratuita.
Frontend,Bootstrap 5,"Diseño mobile-first simple, UX liviana y usabilidad para baja conectividad."
Mapas,Leaflet.js + OpenStreetMap,Librerías gratuitas y ligeras para georreferenciación.

# ---------- 5) Resultado esperado del proyecto (éxito mínimo verificable) ----------

Scenario: Criterios de éxito mínimos (MVP)

Given La plataforma inicial implementa módulos de Reportes, Seguimiento de Obras, Participación Comunitaria y Panel Administrativo

When Se pone en operación en una zona piloto

Then Debe permitir:

| Función |

| Registrar reportes con evidencia y georreferencia |

| Validar y clasificar reportes por un analista |

| Asignar órdenes de trabajo y registrar avances |

| Descargar reportes y generar estadísticas básicas |

| Notificar a gestores por correo en incidentes críticos |

And El éxito será medido por: reducción del tiempo medio de respuesta inicial y aumento en la trazabilidad de incidentes cerrados