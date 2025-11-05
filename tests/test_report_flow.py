import pytest

pytestmark = pytest.mark.skip("Pendiente de autorización para desarrollar pruebas de integración (US-001 / PRO-17..21)")


def test_end_to_end_report_creation_flow():
    """
    Flujo E2E (resumido) basado en USER_STORIES.md US-001:
    - Ciudadano accede al formulario
    - Completa ubicación y descripción (foto/email opcionales)
    - Sistema guarda con ID único y estado 'recibido'
    - (Acuse de recibo si se proporcionó email)
    """
    # TODO: Implementar con client de Django y asserts cuando se autorice
    pass
