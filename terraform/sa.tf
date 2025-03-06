resource "google_service_account" "sa" {
  account_id   = "${var.service_name}-${var.environment}-sa"
  display_name = "Service Account for ${var.service_name} (${var.environment})"
}

# Permissões para a conta de serviço
resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.sa.email}"
}



resource "google_storage_bucket_iam_member" "bucket_admin" {
    bucket = google_storage_bucket.flow_bucket.name
    role   = "roles/storage.admin"
    member = "serviceAccount:${google_service_account.sa.email}"
}
