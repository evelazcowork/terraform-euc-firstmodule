#Declare the variables for the Region
variable "azregion" {
  type        = string
  description = "This is the Azure Region where the resources will be created"
  default     = "East US"
}

#Declare the variables for the Storage Account Name
variable "storagename" {
  type        = string
  description = "This is the Azure Storage Account Name"
  default     = "eucstoragesandbox"
}

#Declare the variables for the Access Tier
variable "accesstier" {
  type        = string
  description = "This is the Azure Access Tier for the Storage Account"
  default     = "Standard"
}

#Declare the variables for the Replication Type
variable "replicationtype" {
  type        = string
  description = "This is the Azure Replication Type for the Storage Account"
  default     = "LRS"
}
