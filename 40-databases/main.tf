resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.database_subnet_id
    
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-mongodb" # roboshop-dev-mongodb
        }
    )
}


resource "terraform_data" "mongodb" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
    }
  
# Provisioning the MongoDB instance with a bootstrap script. The script will be copied to the instance and executed remotely.

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

# The remote-exec provisioner will execute the bootstrap script on the MongoDB instance.
    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mongodb dev"
        ]
    }
}


# redis instance can be created in a similar way as mongodb instance by replacing the security group id, subnet id and tags accordingly.

resource "aws_instance" "redis" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.redis_sg_id]
    subnet_id = local.database_subnet_id
    
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-redis" # roboshop-dev-redis
        }
    )
}


resource "terraform_data" "redis" {
    triggers_replace = [
        aws_instance.redis.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
    }
  
# Provisioning the redis instance with a bootstrap script. The script will be copied to the instance and executed remotely.

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

# The remote-exec provisioner will execute the bootstrap script on the redis instance.
    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh redis dev"
        ]
    }
}

# rabbitmq instance can be created in a similar way as mongodb instance by replacing the security group id, subnet id and tags accordingly.

resource "aws_instance" "rabbitmq" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.rabbitmq_sg_id]
    subnet_id = local.database_subnet_id
    
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-rabbitmq" # roboshop-dev-rabbitmq
        }
    )
}


resource "terraform_data" "rabbitmq" {
    triggers_replace = [
        aws_instance.rabbitmq.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.rabbitmq.private_ip
    }
  
# Provisioning the rabbitmq instance with a bootstrap script. The script will be copied to the instance and executed remotely.

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

# The remote-exec provisioner will execute the bootstrap script on the rabbitmq instance.
    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh rabbitmq dev"
        ]
    }
}

# mysql instance can be created in a similar way as mongodb instance by replacing the security group id, subnet id and tags accordingly.

resource "aws_instance" "mysql" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id = local.database_subnet_id
    
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-mysql" # roboshop-dev-mysql
        }
    )
}

resource "aws_instance" "mysql" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id = local.database_subnet_id
    iam_instance_profile = aws_iam_instance_profile.mysql.name
    
    tags = merge (
        local.common_tags,
        {
            Name = "${local.common_name_suffix}-mysql" # roboshop-dev-mysql
        }
    )
}

resource "aws_iam_instance_profile" "mysql" {
    name = "mysql"
    role = "EC2SSMParameterRead"
}


resource "terraform_data" "mysql" {
    triggers_replace = [
        aws_instance.mysql.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
    }
  
# Provisioning the mysql instance with a bootstrap script. The script will be copied to the instance and executed remotely.

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

# The remote-exec provisioner will execute the bootstrap script on the mysql instance.
    provisioner "remote-exec" {
        inline =[
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mysql dev"
        ]
    }
}

#route53 record created for mongodb insance to access it using a domain name instead of IP address. The record will be created in the hosted zone specified by the zone_id variable and will have a name in the format of mongodb-environment.domain_name. The record will point to the private IP address of the mongodb instance and will have a TTL of 1 second. The allow_overwrite attribute is set to true to allow updating the record if it already exists.

resource "aws_route53_record" "mongodb" {
    zone_id = var.zone_id
    name    = "mongodb-${var.environment}.${var.domain_name}" # mongodb-dev.countryroot.fun
    type    = "A"
    ttl     = 1
    records = [aws_instance.mongodb.private_ip]
    allow_overwrite = true
}

#route53 record created for redis insance to access it using a domain name instead of IP address. The record will be created in the hosted zone specified by the zone_id variable and will have a name in the format of mongodb-environment.domain_name. The record will point to the private IP address of the mongodb instance and will have a TTL of 1 second. The allow_overwrite attribute is set to true to allow updating the record if it already exists.


resource "aws_route53_record" "redis" {
    zone_id = var.zone_id
    name    = "redis-${var.environment}.${var.domain_name}" # redis-dev.countryroot.fun
    type    = "A"
    ttl     = 1
    records = [aws_instance.redis.private_ip]
    allow_overwrite = true
}

#route53 record created for mysql insance to access it using a domain name instead of IP address. The record will be created in the hosted zone specified by the zone_id variable and will have a name in the format of mongodb-environment.domain_name. The record will point to the private IP address of the mongodb instance and will have a TTL of 1 second. The allow_overwrite attribute is set to true to allow updating the record if it already exists.


resource "aws_route53_record" "mysql" {
    zone_id = var.zone_id
    name    = "mysql-${var.environment}.${var.domain_name}" # mysql-dev.countryroot.fun
    type    = "A"
    ttl     = 1
    records = [aws_instance.mysql.private_ip]
    allow_overwrite = true
}

#route53 record created for rabbitmq insance to access it using a domain name instead of IP address. The record will be created in the hosted zone specified by the zone_id variable and will have a name in the format of mongodb-environment.domain_name. The record will point to the private IP address of the mongodb instance and will have a TTL of 1 second. The allow_overwrite attribute is set to true to allow updating the record if it already exists.


resource "aws_route53_record" "rabbitmq" {
    zone_id = var.zone_id
    name    = "rabbitmq-${var.environment}.${var.domain_name}" # rabbitmq-dev.countryroot.fun
    type    = "A"
    ttl     = 1
    records = [aws_instance.rabbitmq.private_ip]
    allow_overwrite = true
}