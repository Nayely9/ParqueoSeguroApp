import time


def enviar_notificacion_reserva(usuario_id, id_reserva):

    print("Procesando notificación...")

    time.sleep(5)

    print(
        f"Notificación enviada al usuario {usuario_id} "
        f"por la reserva {id_reserva}"
    )