from dotenv import load_dotenv
import os
from datetime import timedelta

load_dotenv()


class Config:

    SQLALCHEMY_DATABASE_URI = (
        f"mysql+pymysql://{os.getenv('DB_USER')}:"
        f"{os.getenv('DB_PASSWORD')}@"
        f"{os.getenv('DB_HOST')}:"
        f"{os.getenv('DB_PORT')}/"
        f"{os.getenv('DB_NAME')}"
    )

    SQLALCHEMY_TRACK_MODIFICATIONS = False

    SECRET_KEY = os.getenv("SECRET_KEY")

    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")


    # Tiempo de vida del token de acceso
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(minutes=30)


    # Tiempo de vida del refresh token
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(days=30)