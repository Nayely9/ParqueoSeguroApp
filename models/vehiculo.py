from extensions import db

class Vehiculo(db.Model):

    __tablename__ = "vehiculos"

    id_vehiculo = db.Column(db.Integer, primary_key=True)

    id_usuario = db.Column(
        db.Integer,
        db.ForeignKey("usuarios.id_usuario"),
        nullable=False
    )

    placa = db.Column(db.String(15), unique=True, nullable=False)

    marca_modelo = db.Column(db.String(100), nullable=False)