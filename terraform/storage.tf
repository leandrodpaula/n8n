


resource "google_storage_bucket" "flow_bucket" {
  name       = "${var.service_name}-data-${var.environment}"
  location   = var.region
  project   = var.project_id
  storage_class = "STANDARD"
  public_access_prevention = "enforced"
  depends_on = [google_project_service.googleapis]
  force_destroy = false
  uniform_bucket_level_access = false
  labels = {
    environment  = var.environment
    service_name = var.service_name
    project      = var.project_id
  }
  versioning {
    enabled = false
  }
  autoclass{
    enabled = false
    terminal_storage_class = "NEARLINE"
  }
}






