from extensions import db

class Reserva(db.Model):

    __tablename__ = "reservas"

    id_reserva = db.Column(db.Integer, primary_key=True)

    id_usuario = db.Column(
        db.Integer,
        db.ForeignKey("usuarios.id_usuario"),
        nullable=False
    )

    id_vehiculo = db.Column(
        db.Integer,
        db.ForeignKey("vehiculos.id_vehiculo"),
        nullable=False
    )

    id_zona = db.Column(
        db.Integer,
        db.ForeignKey("zonas_parqueo.id_zona"),
        nullable=False
    )

    fecha_reserva = db.Column(db.Date, nullable=False)

    hora_inicio = db.Column(db.Time, nullable=False)

    hora_fin = db.Column(db.Time)

    monto_total = db.Column(db.Numeric(10,2))


    usuario = db.relationship(
        "Usuario",
        backref="reservas"
    )

    vehiculo = db.relationship(
        "Vehiculo",
        backref="reservas"
    )

    zona = db.relationship(
        "Zona",
        backref="reservas"
    )