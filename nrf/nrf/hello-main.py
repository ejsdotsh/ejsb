# main.py

from fastapi import FastAPI

app = FastAPI()


@app.get("/items/{item_id}")
async def read_item(item_id: int) -> dict[str, int]:
    return {"item_id": item_id}


@app.get("/")
async def root() -> dict[str, str]:
    return {"message": "Hello World"}
