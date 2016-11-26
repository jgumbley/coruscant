resource "aws_instance" "web" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    security_groups = [
      "${aws_security_group.allow_ssh.name}",
    ]
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
