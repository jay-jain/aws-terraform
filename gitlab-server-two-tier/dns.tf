# DNS Record
resource "aws_route53_record" "gitlab" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.gitlab_name}.${var.dns_zone_name}"
  type    = "CNAME"
  ttl     = "300"  
  # records = [aws_instance.gitlab.public_ip] ### Use this line if you are using EC2 instance
  records = [aws_lb.gitlab.dns_name]
}

# Retrieves Hosted Zone Resource (Use this if the Hosted Zones has already been created)
# Highly recommended to manually create hosted zone and use this data source to get hosted zone attributes
data "aws_route53_zone" "zone" {
  name         = "${var.dns_zone_name}."
  private_zone = false
}

#### This is for creating the certificate in ACM, validating the certicate, and adding the CNAME record ####

# # Creates the alias record to the IP address of the GitLab server. 
# # Note, use CNAME when mapping to an ELB

# resource "aws_route53_record" "gitlab" {
#   zone_id = data.aws_route53_zone.zone.zone_id
#   name    = "${var.gitlab_name}.${data.aws_route53_zone.zone.name}"
#   type    = "A"
#   ttl     = "300"
#   records = [aws_instance.gitlab.public_ip]
# }

# # Creates the CNAME record for the cert validation
# resource "aws_route53_record" "cert_validation" {
#   name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
#   type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
#   zone_id = data.aws_route53_zone.zone.id
#   records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
#   ttl     = 60
# }

# ## Validates the certificate
# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
# }

# ## Creates the SSL Certificate in Amazon Cert Manager
# resource "aws_acm_certificate" "cert" {
#   domain_name       = "*.${var.dns_zone_name}"
#   validation_method = "DNS"
# }