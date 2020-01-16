variable "appname" {
  type        = string
  description = "Application name. Use only lowercase letters and numbers"
  default     = "sample"
}

variable "domainprefix" {
  type        = string
  description = "Domain prefix. Use only lowercase letters and numbers"
  default     = "aztf"
}

variable "environment" {
  type        = string
  description = "Environment name, e.g. 'dev' or 'stage'"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region where to create resources."
  default     = "West US"
}

variable "department" {
  type        = string
  description = "Passed from the build pipeline and used to tag resources."
  default     = "foo"
}
