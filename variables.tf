variable "location" {
  default     = "East US"
  description = "Azure region for the resources"
}

variable "prefix" {
  description = "prefix of the deployment stage"
}
variable "resource_group_name" {
  description = "rg-gunnugupta1999"
}

# variable "vnetAdressSpace" {
# description = "adress space for vnet"
# type        = list(string)
# }