from pydantic import BaseModel

class Products(BaseModel):
    maskProduct: str
    productName: str
    isEnabled: str


class ProductsOut(Products):
    class Config:
        from_attributes = True
