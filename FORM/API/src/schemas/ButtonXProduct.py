from pydantic import BaseModel


class ButtonXProduct(BaseModel):
    maskProduct: str
    quantity: int
    screen: int