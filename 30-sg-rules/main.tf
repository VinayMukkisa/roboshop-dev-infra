#security group rule to allow traffic from bastion host to backend ALB on port number 80 and protocol TCP. This will allow us to access the backend ALB from the bastion host for testing and troubleshooting purposes.
resource "aws_security_group_rule" "backend_alb" {
  type              = "ingress"
  security_group_id = local.backend_alb_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}
#to allow SSH access to the bastion host from anywhere in the world. This will allow us to connect to the bastion host from our local machine for testing and troubleshooting purposes. In a production environment, you should restrict this rule to only allow access from trusted IP addresses or ranges.
resource "aws_security_group_rule" "bastion" {
  type              = "ingress"
  security_group_id = local.bastion_sg_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

#security group rule to allow traffic from bastion host to MongoDB instance on port number 22 and protocol TCP. This will allow us to SSH into the MongoDB instance from the bastion host for testing and troubleshooting purposes.
  resource "aws_security_group_rule" "mongodb_bastion" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

#security group rule to allow traffic from bastion host to Redis instance on port number 22 and protocol TCP. This will allow us to SSH into the Redis instance from the bastion host for testing and troubleshooting purposes.

resource "aws_security_group_rule" "redis_bastion" {
  type              = "ingress"
  security_group_id = local.redis_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

#security group rule to allow traffic from bastion host to RabbitMQ instance on port number 22 and protocol TCP. This will allow us to SSH into the RabbitMQ instance from the bastion host for testing and troubleshooting purposes.
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type              = "ingress"
  security_group_id = local.rabbitmq_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

#security group rule to allow traffic from bastion host to MySQL instance on port number 22 and protocol TCP. This will allow us to SSH into the MySQL instance from the bastion host for testing and troubleshooting purposes.

resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  security_group_id = local.mysql_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

#security group rule to allow traffic from bastion host to catalogue instance on port number 22 and protocol TCP. This will allow us to SSH into the catalogue instance from the bastion host for testing and troubleshooting purposes.


resource "aws_security_group_rule" "catalogue_bastion" {
  type              = "ingress"
  security_group_id = local.catalogue_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}
#security group rule to allow traffic from catalogue instance to MongoDB instance on port number 27017 and protocol TCP. This will allow the catalogue service to connect to the MongoDB instance for database operations.

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id
  source_security_group_id = local.catalogue_sg_id
  from_port         = 27017
  protocol          = "tcp"
  to_port           = 27017
}

resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  security_group_id = local.catalogue_sg_id
  source_security_group_id = local.backend_alb_sg_id
  from_port         = 8080
  protocol          = "tcp"
  to_port           = 8080
}

