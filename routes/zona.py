from flask import Blueprint, request, jsonify
from extensions import db, cache
from models.zona import Zona
from flask_jwt_extended import jwt_required


zona = Blueprint(
    "zona",
    __name__
)


@zona.route("/", methods=["POST"])
@jwt_required()
def crear_zona():

    datos = request.get_json()

    nueva_zona = Zona(
        id_parqueadero=datos["id_parqueadero"],
        codigo_plaza=datos["codigo_plaza"],
        estado=datos.get("estado", "Disponible")
    )

    db.session.add(nueva_zona)
    db.session.commit()

    return jsonify({
        "mensaje": "Zona creada correctamente"
    }), 201



@zona.route("/", methods=["GET"])
@cache.cached(timeout=60)
def listar_zonas():

    zonas = Zona.query.all()

    resultado = []

    for z in zonas:
        resultado.append({
            "id": z.id_zona,
            "parqueadero": z.id_parqueadero,
            "codigo": z.codigo_plaza,
            "estado": z.estado
        })

    return jsonify(resultado)