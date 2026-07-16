from flask import Blueprint, request, jsonify
from extensions import db
from models.parqueadero import Parqueadero
from flask_jwt_extended import jwt_required


parqueadero = Blueprint(
    "parqueadero",
    __name__
)


@parqueadero.route("/", methods=["POST"])
@jwt_required()
def crear_parqueadero():

    datos = request.get_json()

    nuevo = Parqueadero(
        nombre=datos["nombre"],
        direccion=datos["direccion"],
        capacidad_total=datos["capacidad_total"],
        tarifa_hora=datos["tarifa_hora"]
    )

    db.session.add(nuevo)
    db.session.commit()

    return jsonify({
        "mensaje": "Parqueadero creado correctamente"
    }), 201



@parqueadero.route("/", methods=["GET"])
def listar_parqueaderos():

    parqueaderos = Parqueadero.query.all()

    resultado = []

    for p in parqueaderos:
        resultado.append({
            "id": p.id_parqueadero,
            "nombre": p.nombre,
            "direccion": p.direccion,
            "capacidad": p.capacidad_total,
            "tarifa": str(p.tarifa_hora)
        })

    return jsonify(resultado)