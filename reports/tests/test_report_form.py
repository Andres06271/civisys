import pytest

pytestmark = pytest.mark.skip("Pendiente de autorización para desarrollar pruebas detalladas (US-001 / PRO-17)")


class TestReportCreateForm:
    """
    US-001: Reportar un incidente de derrumbe
    PRO-17: Formulario básico de reporte de incidente

    Criterios base desde USER_STORIES.md:
    - Campos obligatorios: ubicación (mapa), descripción
    - Foto y email: opcionales
    """

    def test_form_requires_location_and_description(self):
        # TODO: Validar que 'location' y 'description' sean obligatorios
        pass

    def test_form_accepts_optional_photo_and_email(self):
        # TODO: Validar que 'photo' y 'citizen_email' sean opcionales
        pass
