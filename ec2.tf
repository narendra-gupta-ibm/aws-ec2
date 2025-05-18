provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "linux_ec2" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI for us-east-1 (update if needed)
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"

  tags = {
    Name = "EC2-With-ExtraDisk"
  }
}

# Create additional 10GB EBS volume
resource "aws_ebs_volume" "extra_disk" {
  availability_zone = aws_instance.linux_ec2.availability_zone
  size              = 10 # Size in GB
  type              = "gp2"

  tags = {
    Name = "ExtraDisk"
  }
}

# Attach EBS volume to EC2 instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.extra_disk.id
  instance_id = aws_instance.linux_ec2.id
}
