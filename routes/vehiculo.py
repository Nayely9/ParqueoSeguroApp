from flask import Blueprint, request, jsonify
from extensions import db
from models.vehiculo import Vehiculo
from flask_jwt_extended import jwt_required, get_jwt_identity


vehiculo = Blueprint("vehiculo", __name__)


@vehiculo.route("/", methods=["POST"])
@jwt_required()
def crear_vehiculo():

    usuario_id = get_jwt_identity()

    datos = request.get_json()

    nuevo_vehiculo = Vehiculo(
        id_usuario=usuario_id,
        placa=datos["placa"],
        marca_modelo=datos["marca_modelo"]
    )

    db.session.add(nuevo_vehiculo)
    db.session.commit()

    return jsonify({
        "mensaje": "Vehículo registrado correctamente"
    }), 201



@vehiculo.route("/", methods=["GET"])
@jwt_required()
def listar_vehiculos():

    usuario_id = get_jwt_identity()

    vehiculos = Vehiculo.query.filter_by(
        id_usuario=usuario_id
    ).all()

    resultado=[]

    for v in vehiculos:
        resultado.append({
            "id": v.id_vehiculo,
            "placa": v.placa,
            "marca_modelo": v.marca_modelo
        })

    return jsonify(resultado)

@vehiculo.route("/<int:id_vehiculo>", methods=["PUT"])
@jwt_required()
def actualizar_vehiculo(id_vehiculo):

    usuario_id = get_jwt_identity()

    vehiculo = Vehiculo.query.filter_by(
        id_vehiculo=id_vehiculo,
        id_usuario=usuario_id
    ).first()

    if not vehiculo:
        return jsonify({
            "mensaje": "Vehículo no encontrado"
        }), 404

    datos = request.get_json()

    vehiculo.placa = datos["placa"]
    vehiculo.marca_modelo = datos["marca_modelo"]

    db.session.commit()

    return jsonify({
        "mensaje": "Vehículo actualizado correctamente"
    })

@vehiculo.route("/<int:id_vehiculo>", methods=["DELETE"])
@jwt_required()
def eliminar_vehiculo(id_vehiculo):

    usuario_id = get_jwt_identity()

    vehiculo = Vehiculo.query.filter_by(
        id_vehiculo=id_vehiculo,
        id_usuario=usuario_id
    ).first()

    if not vehiculo:
        return jsonify({
            "mensaje": "Vehículo no encontrado"
        }), 404

    db.session.delete(vehiculo)
    db.session.commit()

    return jsonify({
        "mensaje": "Vehículo eliminado correctamente"
    })