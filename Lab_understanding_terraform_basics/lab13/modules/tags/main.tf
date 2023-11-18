# ./modules/tags/main.tf

variable "default_tags" {
  description = "Default tags to be applied to all resources"
  type        = map(string)
}
