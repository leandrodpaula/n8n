# Rede VPC
resource "google_compute_network" "vpc_network" {
  name                    = "${var.service_name}-${var.environment}-vpc-network"
  auto_create_subnetworks = true
}

# Subrede específica para o Cloud SQL
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.service_name}-${var.environment}-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_global_address" "private_ip_address" {

  name          = "${var.service_name}-${var.environment}-database-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "flow_subnet" {
  name          = "${var.service_name}-${var.environment}-flow-subnet"
  ip_cidr_range = "10.10.1.0/28"
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}



# VPC Connector para o Cloud Run
resource "google_vpc_access_connector" "cloud_run_connector" {
  name          = "${var.service_name}-${var.environment}-connector"
  region        = var.region
  subnet {
    name = google_compute_subnetwork.flow_subnet.name
  }
  min_instances = 2
  max_instances = 3
}


# Firewall rule to allow internet outbound traffic
resource "google_compute_firewall" "allow_internet_outbound" {
  name    = "${var.service_name}-${var.environment}-allow-internet-outbound"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  direction = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
}