# Declaring the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.amzlinux2.id
  instance_type = "t2.medium"
  #subnet_id = ??
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = "jptechkey" # Existing ssh key
  user_data              = file("jenkins-docker-script.sh")

  tags = {
    Name = "jenkins_server"
  }
}

# an empty resource block
resource "null_resource" "name" {
  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/Downloads/jptechkey.pem")
    host        = aws_instance.ec2_instance.public_ip
  }

  # copy the jenkins-docker-script.sh file from your computer to the ec2 instance 
  provisioner "file" {
    source      = "jenkins-docker-script.sh"
    destination = "/tmp/jenkins-docker-script.sh"
  }

  # set permissions and run the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/jenkins-docker-script.sh",
      "sh /tmp/jenkins-docker-script.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.ec2_instance]
}


# print the url of the jenkins server
output "website_url" {
  value = join("", ["http://", aws_instance.ec2_instance.public_dns, ":", "8080"])
}