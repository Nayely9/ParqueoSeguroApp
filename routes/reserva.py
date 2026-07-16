from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from sqlalchemy.orm import joinedload
from threading import Thread

from extensions import db, cache
from models.reserva import Reserva
from models.zona import Zona
from tasks.notificaciones import enviar_notificacion_reserva

reserva = Blueprint("reserva", __name__)


@reserva.route("/", methods=["POST"])
@jwt_required()
def crear_reserva():

    usuario_id = get_jwt_identity()
    datos = request.get_json()

    # Verificar que la zona exista
    zona = Zona.query.filter_by(id_zona=datos["id_zona"]).first()

    if not zona:
        return jsonify({
            "mensaje": "La zona no existe"
        }), 404

    # Verificar que la zona esté disponible
    if zona.estado == "Ocupado":
        return jsonify({
            "mensaje": "La zona ya está ocupada"
        }), 400

    nueva = Reserva(
        id_usuario=usuario_id,
        id_vehiculo=datos["id_vehiculo"],
        id_zona=datos["id_zona"],
        fecha_reserva=datos["fecha_reserva"],
        hora_inicio=datos["hora_inicio"],
        hora_fin=datos["hora_fin"],
        monto_total=datos["monto_total"]
    )

    # Cambiar estado de la zona
    zona.estado = "Ocupado"

    db.session.add(nueva)
    db.session.commit()

    Thread(
    target=enviar_notificacion_reserva,
    args=(usuario_id, nueva.id_reserva)
).start()

    return jsonify({
        "mensaje": "Reserva creada correctamente"
    }), 201


@reserva.route("/", methods=["GET"])
@jwt_required()
def listar_reservas():

    usuario_id = get_jwt_identity()

    reservas = Reserva.query.options(
    joinedload(Reserva.vehiculo),
    joinedload(Reserva.zona),
    joinedload(Reserva.usuario)
).filter_by(
    id_usuario=usuario_id
).all()

    resultado = []

    for r in reservas:
        resultado.append({

    "id": r.id_reserva,

    "usuario": r.usuario.id_usuario,

    "vehiculo": {
        "placa": r.vehiculo.placa,
        "marca_modelo": r.vehiculo.marca_modelo
    },

    "zona": {
        "codigo_plaza": r.zona.codigo_plaza,
        "estado": r.zona.estado
    },

    "fecha": str(r.fecha_reserva),

    "hora_inicio": str(r.hora_inicio),

    "hora_fin": str(r.hora_fin),

    "total": str(r.monto_total)

})

    return jsonify(resultado)


@reserva.route("/<int:id_reserva>", methods=["DELETE"])
@jwt_required()
def cancelar_reserva(id_reserva):

    usuario_id = get_jwt_identity()

    reserva = Reserva.query.filter_by(
        id_reserva=id_reserva,
        id_usuario=usuario_id
    ).first()

    if not reserva:
        return jsonify({
            "mensaje": "Reserva no encontrada"
        }), 404

    # Liberar la zona
    zona = Zona.query.get(reserva.id_zona)
    if zona:
        zona.estado = "Disponible"

    db.session.delete(reserva)
    db.session.commit()

    return jsonify({
        "mensaje": "Reserva cancelada correctamente"
    })