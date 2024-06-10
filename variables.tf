variable "domain_name" {
  description = "This is the domain name of Certificate to create"
  type        = string
}

variable "zone_name" {
  description = "This is the name of the Public Zone where the certificate will be associated"
  type        = string
}

variable "environment" {
  description = "Environment to be used on all the resources as identifier"
}

variable "subject_alternative_names" {
  type        = list(string)
  default     = []
  description = "A list of domains that should be SANs in the issued certificate"
}

variable "wildcard" {
  type        = bool
  default     = true
  description = "Include or not * alternative name"
}