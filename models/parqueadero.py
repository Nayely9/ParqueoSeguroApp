from extensions import db


class Parqueadero(db.Model):

    __tablename__ = "parqueaderos"

    id_parqueadero = db.Column(
        db.Integer,
        primary_key=True
    )

    nombre = db.Column(
        db.String(100),
        nullable=False
    )

    direccion = db.Column(
        db.String(255),
        nullable=False
    )

    capacidad_total = db.Column(
        db.Integer,
        nullable=False
    )

    tarifa_hora = db.Column(
        db.Numeric(10, 2),
        nullable=False
    )

    # ==========================================
    # COORDENADAS DEL PARQUEADERO
    # ==========================================

    latitud = db.Column(
        db.Float,
        nullable=True
    )

    longitud = db.Column(
        db.Float,
        nullable=True
    )