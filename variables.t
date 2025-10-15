variable "credentials_file" {
  type        = string
  description = "Ruta del archivo de credenciales JSON de GCP (Perú)"
}

variable "credentials_content" {
  type        = string
  description = "Contenido JSON de las credenciales GCP (Perú)"
}

variable "project_id" {
  description = "ID del proyecto en GCP para Perú"
  type        = string
}

variable "region" {
  description = "Región donde se desplegará la VM para Perú"
  type        = string
  default     = "southamerica-east1" # región de Sudamérica (por ejemplo, São Paulo)
}

variable "zone" {
  description = "Zona de despliegue para Perú"
  type        = string
  default     = "southamerica-east1-b"
}

variable "instance_name" {
  description = "Nombre de la VM de Oracle para Perú"
  type        = string
  default     = "oracle-db-instance-pe"
}

variable "machine_type" {
  description = "Tipo de máquina para Perú"
  type        = string
  default     = "e2-medium"
}

variable "image" {
  description = "Imagen base de la VM (Oracle Linux) para Perú"
  type        = string
  default     = "projects/oracle-linux-cloud/global/images/family/oracle-linux-8"
}

