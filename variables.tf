variable "create" {
    type    = bool
    default = true
}
variable "name" {
    type    = string
}
variable "path" {
    type    = string
    default = "/"
}
variable "description" {
    type    = string
    default = ""
}
variable "force_detach_policies" {
    type    = bool
    default = false
}
variable "max_session_duration" {
    type    = number
    default = 3600
}
variable "iam_policy" {
    type    = any
    default = []
}
variable "assume_role_policy" {
    type    = any
    default = []
}
variable "default_tags" {
    type    = map(string)
    default = {}
}




