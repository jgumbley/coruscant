resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow inbound ssh traffic"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "web" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    security_groups = [ "${aws_security_group.allow_ssh.name}" ]
    key_name = "deployer-key"
    tags {
        Name = "${var.tag}"
    }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key" 
  public_key = "${file("../deploy_key.pub")}"
}

output "ip" {
    value = "${aws_instance.web.public_ip}"
}
