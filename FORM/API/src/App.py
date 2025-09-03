from fastapi import FastAPI
from src.controllers import ButtonsCrontoller


def create_app():
    app = FastAPI()

    button = ButtonsCrontoller()

    app.include_router(button.buttons)

    return app