import click
import uvicorn
from fastapi import FastAPI

app = FastAPI()


@app.get("/api/hello")
def hello():
    return {"message": "Hello World"}


@click.pass_context
@click.option("--port", default=9345)
def server(ctx: click.Context, port: int):
    debug = ctx.obj["debug"]
    uvicorn.run("be.server:app",
                port=port,
                log_level="debug" if debug else "info",
                reload=debug)
