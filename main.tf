provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXMIGROHVMKADCO5W"
  secret_key = "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"
}

resource "aws_security_group" "test1" {
  name        = "test1"
  description = "Allow inbound SSH"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
ingress {
     description = "HTTP"
     from_port   = 8080
     to_port     = 8080
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


resource "aws_instance" "web1" {
  ami           = "ami-02396cdd13e9a1257"  
  instance_type = "t2.micro"

  tags = {
    Name = "Project1"
  }
   key_name = "tejakey"
   user_data = <<-EOF
      #!/bin/bash
        sudo yum install git -y
        sudo amazon-linux-extras install java-openjdk11 -y
        sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
        sudo yum install jenkins -y
        sudo systemctl start jenkins
        sudo yum install python -y
   EOF
}

resource "aws_network_interface_sg_attachment" "sg_attachment1" {

security_group_id = aws_security_group.test1.id

network_interface_id = aws_instance.web1.primary_network_interface_id

}
