resource "google_sql_database_instance" "postgres_instance" {
  project          = var.project_id
  name             = "${var.service_name}-${var.environment}-pg-instance"
  region           = var.region
  database_version = "POSTGRES_15" # Specify your desired PostgreSQL version

  settings {
    tier    = "db-f1-micro" # Choose an appropriate machine type
    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.vpc_network.id
    }
  }
  deletion_protection = false # Set to true for production environments
  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "postgres_database" {
  project  = var.project_id
  instance = google_sql_database_instance.postgres_instance.name
  name     = "${var.service_name}_db" # Define your database name
}

resource "google_sql_user" "postgres_user" {
  project  = var.project_id
  instance = google_sql_database_instance.postgres_instance.name
  name     = "${var.service_name}_user" # Define your database user
  password = google_secret_manager_secret_version.db_password_version.secret_data
}