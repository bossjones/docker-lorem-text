#!/usr/bin/env python
import logging
import sys
from types import FrameType
from typing import cast
from lorem_text import lorem
from loguru import logger
import threading
import time

logger = logging.getLogger("app")
logger.setLevel("DEBUG")

class InterceptHandler(logging.Handler):
    def emit(self, record: logging.LogRecord) -> None:  # pragma: no cover
        # Get corresponding Loguru level if it exists
        try:
            level = logger.level(record.levelname).name
        except ValueError:
            level = str(record.levelno)

        # Find caller from where originated the logged message
        frame, depth = logging.currentframe(), 2
        while frame.f_code.co_filename == logging.__file__:  # noqa: WPS609
            frame = cast(FrameType, frame.f_back)
            depth += 1

        logger.opt(depth=depth, exception=record.exc_info).log(
            level, record.getMessage(),
        )

DEBUG = True

LOGGING_LEVEL = logging.DEBUG if DEBUG else logging.INFO
LOGGERS = ("app")

logging.getLogger().handlers = [InterceptHandler()]
for logger_name in LOGGERS:
    logging_logger = logging.getLogger(logger_name)
    logging_logger.handlers = [InterceptHandler(level=LOGGING_LEVEL)]

logger.configure(handlers=[{"sink": sys.stderr, "level": LOGGING_LEVEL}])


counter = 1

while counter < 20:
    msg = lorem.sentence()
    logging.info(f"{counter} - {msg}")
    counter = counter + 1
    time.sleep(0.75)


