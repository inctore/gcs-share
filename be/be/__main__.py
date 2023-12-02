#!/usr/bin/env python

import logging
import click

from .server import server

LOGGER = logging.getLogger(__name__)


def setup_logging(debug: bool):
    """Setup logging configuration"""
    logging.basicConfig(
        level=logging.DEBUG if debug else logging.INFO,
        format="%(asctime)s %(levelname)s %(name)s %(message)s"
    )


@click.group()
@click.option("--debug", is_flag=True, help="Enable debug logging")
@click.pass_context
def main(ctx: click.Context, debug: bool):
    ctx.obj = {
        "debug": debug
    }
    setup_logging(debug)


if __name__ == "__main__":
    main.command(server)
    main()
