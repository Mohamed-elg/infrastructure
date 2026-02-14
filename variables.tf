variable "environment" {
  description = "Map the environment name to its Id"
  type        = map(number)
  default = {
    "pi"  = 3
    "deb" = 4
  }
}

variable "endpoint" {
  sensitive = true
  type      = string
}

variable "api_key" {
  sensitive = true
  type      = string
}

variable "pi_volume_base_path" {
  sensitive = true
  type      = string
}

variable "deb_volume_base_path" {
  sensitive = true
  type      = string
}

variable "ip" {
  sensitive = true
  type      = string
}

variable "web_password" {
  sensitive = true
  type      = string
}

variable "postgre" {
  sensitive = true
  type = object({
    db   = string
    user = string
    pass = string
  })
}

variable "smb" {
  sensitive = true
  type = object({
    name = string
    user = string
    pass = string
  })
}
