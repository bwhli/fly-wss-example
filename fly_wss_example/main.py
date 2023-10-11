import os
import time
from datetime import datetime
from pathlib import Path

from fastapi import FastAPI, Request, WebSocket
from fastapi.templating import Jinja2Templates

PROJECT_DIR = Path(__file__).resolve().parent
TEMPLATES_DIR = PROJECT_DIR / "templates"

templates = Jinja2Templates(
    directory=TEMPLATES_DIR,
)

app = FastAPI()


@app.get("/")
async def index(request: Request):
    return templates.TemplateResponse(
        "index.html",
        {"request": request,},
    )

@app.websocket("/ws/")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        time.sleep(1)
        current_time = datetime.utcnow().isoformat()
        await websocket.send_text(f'<p id="timestamp" hx-swap-oob="true">Current Time: {current_time}</p>')