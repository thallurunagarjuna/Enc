resource "aws_opensearch_domain" "example" {
  domain_name    = "xenon"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type            = "t3.small.search"
    instance_count           = 6
    dedicated_master_enabled = true
    dedicated_master_type    = "t3.small.search"
    dedicated_master_count   = 3
    zone_awareness_enabled   = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 30
    volume_type = "gp3"
  }

  vpc_options {
    subnet_ids          = ["subnet-05c5d75c44107b80b", "subnet-056436a20f14035ef"]
    
  }

 access_policies = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "es:*",
          "Resource": "arn:aws:es:ap-south-1:292988066530:domain/xenon-poc/*"
        }
      ]
    }
  POLICY

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = 0
  }

  provisioner "local-exec" {
    command = <<EOT
      aws opensearch update-domain-config --domain-name ${aws_opensearch_domain.example.domain_name} --node-to-node-encryption-options Enabled=true
    EOT
  }
}

resource "aws_security_group" "example" {
  name = "example-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "opensearchSecurityGroup"
  }
}
