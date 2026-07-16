from extensions import db

class Usuario(db.Model):

    __tablename__ = "usuarios"

    id_usuario = db.Column(db.Integer, primary_key=True)

    nombre = db.Column(db.String(100), nullable=False)

    email = db.Column(db.String(100), unique=True, nullable=False)

    contrasena = db.Column(db.String(255), nullable=False)

    telefono = db.Column(db.String(15))

    vehiculos = db.relationship(
        "Vehiculo",
        backref="usuario",
        lazy=True
    )