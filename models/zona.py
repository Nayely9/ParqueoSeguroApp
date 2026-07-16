from extensions import db

class Zona(db.Model):

    __tablename__ = "zonas_parqueo"

    id_zona = db.Column(
        db.Integer,
        primary_key=True
    )

    id_parqueadero = db.Column(
        db.Integer,
        db.ForeignKey("parqueaderos.id_parqueadero"),
        nullable=False
    )

    codigo_plaza = db.Column(
        db.String(10),
        nullable=False
    )

    estado = db.Column(
        db.String(20),
        default="Disponible"
    )