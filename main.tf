# This file is used to initialize the deployment

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = "sandbox-egrange-test"
}

resource "google_sql_database_instance" "instance" {
  name             = "fastapi-template-instance"
  region           = "europe-west9"
  database_version = "POSTGRES_15"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = "true"
}

resource "google_sql_database" "database" {
  name     = "fastapi-template_db"
  instance = google_sql_database_instance.instance.name
}

resource "google_cloud_run_service" "backend_service" {
  name     = "fastapi-template"
  location = "europe-west9"

  template {
    spec {
      containers {
        image = "europe-docker.pkg.dev/sandbox-egrange-test/cookiecutter-template/fastapi-template"
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.instance.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_secret_manager_secret" "backend_secret" {
  secret_id = "fastapi-template"

  replication {
    automatic = true
  }
}

