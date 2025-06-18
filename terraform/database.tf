resource "google_alloydb_cluster" "alloydb_cluster" {
  project       = var.project_id
  location      = var.region
  cluster_id    = "${var.service_name}-${var.environment}-alloydb-cluster"
  network_config {
    network = google_compute_network.vpc_network.id
  }
  initial_user {
    user     = "${var.service_name}_user"
    password = google_secret_manager_secret_version.db_password_version.secret_data
  }
  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_alloydb_instance" "alloydb_instance" {
  cluster           = google_alloydb_cluster.alloydb_cluster.name
  instance_id       = "${var.service_name}-${var.environment}-alloydb-instance"
  instance_type     = "PRIMARY" # Basic instance type, consider changing for production
  machine_cpu_count = 2         # Basic machine type
  # availability_type = "REGIONAL" # Or "ZONAL" depending on requirements. Default is ZONAL if not specified.

  # Deletion protection should ideally be true for production environments
  # deletion_protection = false
}

# Note: In AlloyDB, databases are typically created by applications upon connection if they don't exist.
# If a specific database resource is needed at the Terraform level, it would be google_alloydb_database.
# For now, we are relying on the initial_user and application to handle database creation.

# The google_alloydb_user resource is for managing additional users if needed,
# beyond the initial_user specified in the cluster.
# We are using initial_user for simplicity in this migration.