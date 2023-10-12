resource "aws_instance" "Sonarqube" {
  ami                    = data.aws_ami.Ubuntu.id
  instance_type          = "t2.medium"
  user_data              = file("sonar_script.sh")
  vpc_security_group_ids = [aws_security_group.sonarsg.id]
  key_name               = var.my_key

  tags = {
    Name = "Sonarqube_Instance"
  }
}

data "aws_route53_zone" "selected" {
  name         = "jpizzletech.com"
  private_zone = false
}

resource "aws_route53_record" "domainName" {
  name    = "sonar"
  type    = "A"
  zone_id = data.aws_route53_zone.selected.zone_id
  records = [aws_instance.Sonarqube.public_ip]
  ttl     = 60
  depends_on = [
    aws_instance.Sonarqube
  ]
}