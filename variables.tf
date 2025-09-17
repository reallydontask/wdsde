variable "env" {
  description = "Short descriptor for the environment. Used for naming where naming constraints may prevent the use of full environment name."
  type = string
}

variable "environment" {
  description = "The environment for the resources"
  type = string
}

variable "location" {
  default = "uk south"
  description = "azure region"
  type = string
}

variable "subscription_id" {
  type = string
  description = "Subscription Id for the provider set up"
}