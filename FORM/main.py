from fastapi import FastAPI
from src.app import create_app

app = create_app()


if "__main__" == __name__:
    print("Execute")