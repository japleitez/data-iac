variable "key_name" {
  description = "The key name"
  type = string
}

variable "ssh_public_key" {
  description = "The SSH public key"
  type = string
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
}