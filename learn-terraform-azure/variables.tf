# main.tfで、var.resource_group_nameで参照できる
# moduleは、CFnのネストスタックやStackSetsのようなもの
variable "resource_group_name" {
  default = "myTFResourceGroup"
}
