from flask import Blueprint, request, jsonify

from flask_jwt_extended import (
    create_access_token,
    create_refresh_token,
    jwt_required,
    get_jwt_identity
)

from extensions import db
from models.usuario import Usuario

import bcrypt


auth = Blueprint("auth", __name__)


# LOGIN

@auth.route("/login", methods=["POST"])
def login():

    datos = request.get_json()

    email = datos["email"]
    contrasena = datos["contrasena"]


    usuario = Usuario.query.filter_by(
        email=email
    ).first()


    if not usuario:
        return jsonify({
            "mensaje": "Correo o contraseña incorrectos"
        }), 401


    if not bcrypt.checkpw(
        contrasena.encode("utf-8"),
        usuario.contrasena.encode("utf-8")
    ):
        return jsonify({
            "mensaje": "Correo o contraseña incorrectos"
        }), 401


    access_token = create_access_token(
        identity=str(usuario.id_usuario)
    )


    refresh_token = create_refresh_token(
        identity=str(usuario.id_usuario)
    )


    return jsonify({

        "mensaje": "Inicio de sesión exitoso",

        "access_token": access_token,

        "refresh_token": refresh_token,

        "usuario": {
            "id": usuario.id_usuario,
            "nombre": usuario.nombre,
            "email": usuario.email
        }

    }), 200



# RENOVAR TOKEN

@auth.route("/refresh", methods=["POST"])
@jwt_required(refresh=True)
def refresh():

    usuario_id = get_jwt_identity()


    nuevo_token = create_access_token(
        identity=usuario_id
    )


    return jsonify({

        "access_token": nuevo_token

    }), 200 