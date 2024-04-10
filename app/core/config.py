import logging
from typing import List, Optional

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    ENV: str = "local"
    LOG_LEVEL: int = logging.INFO
    LOG_NAME: str = "fastapi-template"
    PROJECT_NAME: str = "fastapi-template"

    API_PREFIX: str = "/api"
    BACKEND_CORS_ORIGINS: List[str] = ["http://localhost:5173", "http://localhost:3000"]

    SQLALCHEMY_DATABASE_URI: str = (
        "postgresql+asyncpg://postgres:postgres@localhost:5434/fastapi-template_db"
    )
    DEFAULT_PAGE_SIZE: int = 20
    MAX_PAGE_SIZE: int = 100

    GITHUB_ACCESS_TOKEN: Optional[str] = None
    GCLOUD_PROJECT_ID: Optional[str] = "sandbox-egrange-test"

    model_config = SettingsConfigDict(env_file=".env")


settings = Settings()
