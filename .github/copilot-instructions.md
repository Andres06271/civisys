# Copilot instructions for Civisys

Purpose and constraints
- Mission: centralize, standardize, and track the full landslide incident lifecycle (Reporte → Validación → Asignación → Seguimiento → Cierre).
- Zero-cost stack only (free/open source). Never propose paid/closed services.
- Source of truth docs: `agents.md`, `ARCHITECTURE.md`, `PROJECT_STRUCTURE.md`, `USER_STORIES.md`, `context/database.sql`.

Architecture at a glance
- Django (MVT) + PostgreSQL/PostGIS + Bootstrap 5 + Leaflet.js; optional DRF for future API.
- Roles via Django Auth Groups (analista, gestor, ingeniero, entidad_externa). Permissions must be enforced in views.
- Media stored locally; email via SMTP (env-configured). Maps use OSM tiles via Leaflet.
- See diagrams and component responsibilities in `ARCHITECTURE.md` (apps: reports, work_orders, authentication, dashboard, audit, api).

Data model essentials (mirror `context/database.sql`)
- Tables: `incident_report`, `work_order` (1:1 with report), `work_order_log` (1:N), `audit_log`. PostGIS Point with SRID 4326.
- Enums: `report_status(recibido|validado|asignado|cerrado|descartado)`, `report_severity(baja|media|alta)`, `work_order_status(pendiente|en_progreso|finalizada)`.
- Index: GIST on `incident_report.location`.
- In Django models, use `django.contrib.gis.db.models` (e.g., `PointField(srid=4326)`) and CharField with `choices` mirroring the SQL enums.

Development workflow (project-specific)
- TDD first (see `agents.md` §4): write failing tests in `/tests` or app-local `tests/` from Gherkin in `USER_STORIES.md`, then implement until green.
- Naming: snake_case for files/functions; docstrings required for new functions/classes (Google or reST style).
- Security by design: use Django auth, Argon2 hashing, strict role checks; every critical action (validar/asignar/cerrar/exportar) must create an `AuditLog` entry.
- GIS is mandatory: always model geospatial fields with GeoDjango and query with spatial filters when relevant.

Implementation patterns and examples
- Reports app: IncidentReport model with `PointField`, `status` (choices from `report_status`), optional `photo_path` and `citizen_email`. Public create view; status lookup by ID is anonymous.
- Work orders: unique FK `report_id`; state transitions per user role. Creating an OT must set report to `asignado` and send SMTP email.
- Bitácoras (work_order_log): append-only; progress 0–100% with validation; updating logs auto-updates `work_order.status` (`pendiente`→`en_progreso`, `finalizada` at 100%).
- Audit: middleware/util to persist `user_id`, action, IP, timestamp on critical endpoints.

Workflows, commands, and env
- Follow `PROJECT_STRUCTURE.md` §11 for typical Django commands and setup; configure env as per `.env.example` in `PROJECT_STRUCTURE.md` §4.4.
- Use local PostgreSQL with PostGIS enabled (`CREATE EXTENSION postgis;`). Do not hardcode secrets; load from environment.

Conventions that differ from “default”
- Prefer server-rendered templates (Bootstrap) and vanilla JS; avoid heavy JS frameworks (connectivity constraints).
- Use Leaflet/OSM only (no Google Maps). Store media on local FS by default.
- Maintain story↔ticket traceability using `USER_STORIES.md` §9 (US-xxx ↔ PRO-xx). Reference relevant PRO-xx in tests, commit messages, and docstrings.

If unsure
- Re-check the source-of-truth docs above; align models to `context/database.sql` exactly; keep to the zero-cost stack; and default to minimal dependencies.
