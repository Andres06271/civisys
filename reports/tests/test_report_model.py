import pytest

pytestmark = pytest.mark.skip("Pendiente de autorización para desarrollar pruebas detalladas (US-001 / PRO-17)")


class TestIncidentReportModel:
    """
    US-001: Reportar un incidente de derrumbe
    PRO-17: Formulario básico de reporte de incidente

    Objetivo del modelo:
    - location: Point (SRID 4326)
    - status: 'recibido' por defecto
    - severity: null hasta validación
    - timestamps: created_at auto
    """

    def test_model_fields_exist(self, db):
        # TODO: Verificar campos y defaults cuando se implemente el modelo
        pass
