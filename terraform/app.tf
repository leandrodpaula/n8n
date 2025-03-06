resource "google_project_service" "googleapis" {
  service = "run.googleapis.com"
  project = var.project_id
}



# Create the Cloud Run service
resource "google_cloud_run_v2_service" "cloud_run" {
  name              = "${var.service_name}-${var.environment}"
  location          = var.region
  ingress           = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false 
  lifecycle {
    create_before_destroy = false
    prevent_destroy = false
  }
  timeouts {
    create = "10m"
  }
  template {

    service_account = google_service_account.sa.email
    vpc_access{
      connector = google_vpc_access_connector.cloud_run_connector.id
      egress = "ALL_TRAFFIC"
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }
    volumes {
        name = "flow_data"
        gcs {
          bucket    = google_storage_bucket.flow_bucket.name
          read_only = false
        }
    }

    containers {
      



      image = "docker.io/n8nio/n8n:latest"
      ports {
        container_port = 5678
      }

      resources {
        startup_cpu_boost = "true"
        cpu_idle = "true"
        limits = {
          cpu = "2"
          memory= "4Gi"
        }
      }

      startup_probe {
        initial_delay_seconds = 30
        timeout_seconds = 30
        period_seconds = 120
        failure_threshold = 3
        tcp_socket {
          port = 5678
          
        }
      }
      liveness_probe {
        initial_delay_seconds = 30
        timeout_seconds = 30
        period_seconds = 120
        http_get {
          path = "/"
        }
      }

      volume_mounts {
        name = "flow_data"
        mount_path = "/n8n/"
      }

        
        env {
          name  = "N8N_BASIC_AUTH_ACTIVE"
          value = "true"
        }
        env {
          name  = "N8N_BASIC_AUTH_USER"
          value = "admin"
        }

        env{
          name = "N8N_CONFIG_FILES"
          value="/n8n/config/"
        }

        env {
          name  = "N8N_BASIC_AUTH_PASSWORD"
           value_source{
            secret_key_ref{
              secret = google_secret_manager_secret_version.n8n_auth_password_version.secret 
              version = "latest"             
            }
          }
        }
        env {
          name  = "DB_TYPE"
          value = "postgresdb"
        }
        env {
          name  = "DB_POSTGRESDB_HOST"
          value = google_sql_database_instance.postgres_instance.private_ip_address
        }
        env {
          name  = "DB_POSTGRESDB_PORT"
          value = "5432"
        }
        env {
          name  = "DB_POSTGRESDB_DATABASE"
          value = google_sql_database.postgres_db.name
        }
        env {
          name  = "DB_POSTGRESDB_USER"
          value = google_sql_user.postgres_user.name
        }
        env {
          name  = "DB_POSTGRESDB_PASSWORD"
            value_source{
            secret_key_ref{
              secret = google_secret_manager_secret_version.db_password_version.secret 
              version = "latest"             
            }
          }
        }
    }
  }

  depends_on =[google_sql_database_instance.postgres_instance]
}

# Permitir acesso público ao Cloud Run
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.cloud_run.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}


