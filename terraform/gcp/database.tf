resource "google_sql_database_instance" "postgres_instance" {
  name             = "${var.service_name}-${var.environment}-postgres-instance"
  region           = var.region
  database_version = "POSTGRES_14"
  depends_on = [google_service_networking_connection.private_vpc_connection]

  deletion_protection = false
  settings {
    tier = "db-f1-micro" # Instância básica para economizar custos
    ip_configuration {
      private_network = google_compute_network.vpc_network.id
      ipv4_enabled    = false # Desativa o IP público
    }
  }

  
}




resource "google_sql_database" "postgres_db" {
  name     = "${var.service_name}_${var.environment}_db"
  instance = google_sql_database_instance.postgres_instance.name
}

resource "google_sql_user" "postgres_user" {
  name     = "${var.service_name}_user"
  instance = google_sql_database_instance.postgres_instance.name
  password = google_secret_manager_secret_version.db_password_version.secret_data
}