# Output the instance public IP
output "satellite_server_public_ip" {
  value = module.redhat_ec2.instance_public_ip
}