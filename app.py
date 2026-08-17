from flask import Flask
from flask_jwt_extended import JWTManager
from flask_cors import CORS

from config import Config

from models.usuario import Usuario
from models.vehiculo import Vehiculo
from models.parqueadero import Parqueadero
from models.zona import Zona
from models.reserva import Reserva

from extensions import db, jwt, cache


app = Flask(__name__)


# =========================
# CONFIGURACIÓN DE CACHE
# =========================

app.config["CACHE_TYPE"] = "SimpleCache"
app.config["CACHE_DEFAULT_TIMEOUT"] = 60

cache.init_app(app)


# =========================
# CONFIGURACIÓN GENERAL
# =========================

app.config.from_object(Config)


# =========================
# EXTENSIONES
# =========================

db.init_app(app)
jwt.init_app(app)
CORS(app)


# =========================
# RUTA PRINCIPAL
# =========================

@app.route("/")
def inicio():
    return {
        "mensaje": "Bienvenido a ParqueoSeguroApp API",
        "estado": "Backend funcionando correctamente"
    }


# =========================
# AUTENTICACIÓN
# =========================

from routes.auth import auth

app.register_blueprint(
    auth,
    url_prefix="/auth"
)


# =========================
# VEHÍCULOS
# =========================

from routes.vehiculo import vehiculo

app.register_blueprint(
    vehiculo,
    url_prefix="/vehiculos"
)


# =========================
# PARQUEADEROS
# =========================

from routes.parqueadero import parqueadero

app.register_blueprint(
    parqueadero,
    url_prefix="/parqueaderos"
)


# =========================
# ZONAS
# =========================

from routes.zona import zona

app.register_blueprint(
    zona,
    url_prefix="/zonas"
)


# =========================
# RESERVAS
# =========================

from routes.reserva import reserva

app.register_blueprint(
    reserva,
    url_prefix="/reservas"
)


# =========================
# INICIAR SERVIDOR
# =========================

if __name__ == "__main__":
    with app.app_context():
        db.create_all()

    app.run(debug=True)