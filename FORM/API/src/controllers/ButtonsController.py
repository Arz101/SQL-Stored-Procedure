from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
from src.schemas import CreateButton
from src.service import Service

class ButtonsCrontoller:
    def __init__(self):
        self.service = Service()
        self.buttons = APIRouter(prefix="/buttons")
        self.templates = Jinja2Templates("templates")
        self.buttons.add_api_route("/get/{buttonMask}/{maskChannel}", self.getButtons, methods=["GET"])
        self.buttons.add_api_route("/index", self.index, methods=["GET"], response_class=HTMLResponse)
        self.buttons.add_api_route("create", self.createButton, methods=["POST"])
        self.buttons.add_api_route("/get/products", self.getProducts, methods=["GET"])

    async def index(self, request: Request):
        return self.templates.TemplateResponse(
            "index.html",
            {"request" : request}
        )

    def getButtons(self, buttonMask: str, maskChannel: str):
        return self.service.get(buttonMask, maskChannel)
        

    async def createButton(self, newButton: CreateButton):
        return self.service.createButton(newButton)
        
    async def getProducts(self):
        ...