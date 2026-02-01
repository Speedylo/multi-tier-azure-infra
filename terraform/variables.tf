variable "private_allowed_ports" {
  description = "Ports allowed to access private subnet services (DB and monitoring VMs)"
  type        = list(number)
  default     = [5432, 9100, 9090, 3000, 22] //PostgreSQL, Node Exporter, Prometheus, Grafana, SSH
}

variable "public_allowed_ports" {
  description = "Ports allowed to access public subnet services (web VM)"
  type        = list(number)
  default     = [80, 22] //HTTP, SSH
}

variable "monitoring_port_public" {
  description = "Ports allowed to be accessed by the monitoring VMs"
  type        = list(number)
  default     = [9100]
}