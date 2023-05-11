variable "aws_region" {
    type = string 
    value = "us-west-2"
}

variable "instance_type" {
    type = string 
    value = "t2.micro"
}

# variable "vpc_id" {
#     type = string 
# }

# variable "subnet_ids" {
#     type = list(string)    
# }

variable "public_key" {
    type = string 
    value = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINqmBvKT+iOW4TAHxAXrWHbiy4L6jpuLVslf7/DO9Aqf lukewyman@gmail.com"
}