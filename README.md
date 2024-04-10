# fastapi-template

================

## Description

Jolie description

## Template Stack

- [FastApi](https://fastapi.tiangolo.com/)
- [SQLModel](https://sqlmodel.tiangolo.com/)
- [SQLAlchemy 2](https://docs.sqlalchemy.org/en/20/)

## Project Setup

- Install [Poetry](https://python-poetry.org/docs/)

- Set config for venv in local

  ```sh
  poetry config virtualenvs.in-project true
  poetry env use 3.11
  poetry install
  ```

- Create and run required databases

  ```bash
  docker compose up -d
  ```

- Apply migrations

  ```sh
  alembic upgrade head
  ```

### Run locally

```sh
# WITHOUT DOCKER (Guess ADC from env)
uvicorn app.main:app --reload          # Or from VSCode launcher

# OR

# WITH DOCKER
Use the launch.json configuration to build and run the container

# (Running the launch is an equivalent to):
docker build -t <image>:<tag> -f Dockerfile .
docker run --name fastapi-template -p 8000:8000 -p 5678:5678 -v "$HOME/.config/gcloud/application_default_credentials.json":/gcp/creds.json --env GOOGLE_APPLICATION_CREDENTIALS=/gcp/creds.json --env GCLOUD_PROJECT=sandbox-egrange-test <image>:<tag>

```

## Tests

```sh
poetry run pytest --cov=app --cov-report=term     # Uses SQLALCHEMY_DATABASE_URI in pyproject.toml
```

## Deployment

### Initialisation

> :warning: **The main.tf file is build from the information passed to cookiecutter. Ensure you answered correctly to all answers or the file won't run**

```bash

# Before running this, replace in main.tf the <FRONT_ROOT_URL> with the URL of your deployed frontend, or remove the variable

cd fastapi-template
terraform init
terraform apply

```

The main.tf file will deploy:

- The Cloud Run service
- A secret in Secret Manager
- The Cloud SQL instance & the link with the Cloud Run service
- The database associated to the instance

Since we don't know the URL of Cloud Run services, add **manually** secret version with .env content.

> :warning: **Change it according to the database you choose**

### Migrations

Run migrations into the instance with Cloud SQL Proxy

## CI/CD

### CI with Github Actions

Use .github/workflows/lint.yaml **by enabling Github Actions API** in your repository

This will run linting for every Pull Request on develop, uat and main branches

### CD with Cloud Build & Cloud Run

.cloudbuild/cloudbuild.yaml is used automatically to deploy to Cloud Run according to your Cloud Build trigger configuration

*Requirements*:

- Create a Cloud Build trigger from GCP:
  - Specify the cloudbuild.yaml path
  - Give repository access to Cloud Build

- Roles:

  - Cloud Build Service Account has Cloud Run Admin role
  - Cloud Build Service Account has Secret Manager Secret Accessor role

## Api docs

- [Swagger](http://localhost:8000/api/docs)

## Maintainers

Eudes Grange
