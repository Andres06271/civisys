import pytest

pytestmark = pytest.mark.skip("Pendiente de autorización para desarrollar pruebas detalladas (US-001 / PRO-17)")


class TestReportCreateView:
    """
    US-001: Reportar un incidente de derrumbe
    PRO-17: Formulario básico de reporte de incidente

    Casos base:
    - GET: Renderiza formulario
    - POST válido: Crea IncidentReport (estado 'recibido') y retorna ID
    - POST sin ubicación: Error de validación
    """

    def test_get_renders_form(self, client):
        # TODO: Probar respuesta 200 y template correcto
        pass

    def test_post_valid_creates_report(self, db, client):
        # TODO: Probar creación con datos válidos y estado por defecto
        pass

    def test_post_missing_location_shows_error(self, db, client):
        # TODO: Probar error cuando falta ubicación
        pass
