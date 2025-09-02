from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
from src.schemas import CreateButton

class ButtonsCrontoller:
    def __init__(self):
        self.buttons = APIRouter(prefix="/buttons")
        self.buttons.add_api_route("/get", self.getButtons, methods=["GET"])
        self.templates = Jinja2Templates("templates")
        self.buttons.add_api_route("/index", self.index, methods=["GET"], response_class=HTMLResponse)
        self.buttons.add_api_route("create", self.createButton, methods=["POST"])
        ...

    async def index(self, request: Request):
        return self.templates.TemplateResponse(
            "index.html",
            {"request" : request}
        )

    async def getButtons(self):
        ...


    async def createButton(self, newButton: CreateButton):
        return newButton