# BASTION EC2 INSTANCE RESOURCES

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.profile.id
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.key_pair.key_name

  tags = {
    "Name" = "${terraform.workspace}-bastion"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${terraform.workspace}-key-pair"
  public_key = var.public_key
}

resource "aws_iam_instance_profile" "profile" {
  name = "${terraform.workspace}-bastion-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name                = "${terraform.workspace}-bastion-role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

resource "aws_security_group" "bastion_sg" {
  name   = "${terraform.workspace}-bastion-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# POSTGRESQL RDS INSTANCE RESOURCES

resource "aws_db_instance" "db_instance" {

  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  engine                 = "postgres"
  engine_version         = "14.6"
  identifier             = "${terraform.workspace}-postgres"
  instance_class         = "db.t3.small"
  parameter_group_name   = "default.postgres14"
  password               = aws_ssm_parameter.db_password.value
  port                   = 5432
  skip_final_snapshot    = true
  username               = aws_ssm_parameter.db_username.value
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${terraform.workspace}-postgres-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets_ids
}

resource "aws_security_group" "db_sg" {
  name   = "${terraform.workspace}-db-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = data.terraform_remote_state.vpc.outputs.public_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/app/bastions/POSTGRES_USER_NAME"
  type  = "String"
  value = "appuser"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/app/bastions/POSTGRES_PASSWORD"
  type  = "SecureString"
  value = random_password.password.result
}

resource "random_password" "password" {
  length  = 8
  special = false
}