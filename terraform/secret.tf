# Gerar senhas aleatórias usando o provider random
resource "random_password" "n8n_auth_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Armazenar senhas no Google Secret Manager
resource "google_secret_manager_secret" "n8n_auth_password_secret" {
  secret_id = "${var.service_name}-${var.environment}-auth-password"

  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "n8n_auth_password_version" {
  secret     = google_secret_manager_secret.n8n_auth_password_secret.name
  secret_data = random_password.n8n_auth_password.result
}

resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = "${var.service_name}-${var.environment}-db-password"

   replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret     = google_secret_manager_secret.db_password_secret.name
  secret_data = random_password.db_password.result
}

# Permitir que o Cloud Run acesse os segredos
resource "google_secret_manager_secret_iam_member" "cloud_run_access_n8n_auth_password" {
  secret_id = google_secret_manager_secret.n8n_auth_password_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_secret_manager_secret_iam_member" "cloud_run_access_db_password" {
  secret_id = google_secret_manager_secret.db_password_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.sa.email}"
}