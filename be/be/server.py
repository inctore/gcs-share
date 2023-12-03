import click
from starlette.responses import FileResponse
import uvicorn
from fastapi import FastAPI

from .utils import get_port


app = FastAPI()


@app.get("/api/hello")
def hello():
    return {"message": "Hello World"}


@app.get("/vite.svg")
def vite() -> FileResponse:
    return FileResponse("static/vite.svg")


@app.get("/assets/{path:path}")
def assets(path: str) -> FileResponse:
    return FileResponse(f"static/assets/{path}")


@app.get("/{path:path}")
async def index(path: str) -> FileResponse:
    return FileResponse("static/index.html")


@click.pass_context
@click.option("--port", default=get_port())
def server(ctx: click.Context, port: int):
    debug = ctx.obj["debug"]
    uvicorn.run("be.server:app",
                port=port,
                log_level="debug" if debug else "info",
                reload=debug)
