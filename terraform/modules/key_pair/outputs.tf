output "key_name" {
  description = "Name of the AWS key pair."
  value       = aws_key_pair.this.key_name
}

output "private_key_filename" {
  description = "Local path where the private key PEM file was saved. This path is relative to where Terraform was executed."
  value = local_file.private_key.filename
}

output "public_key" {
  description = "Public key material in OpenSSH format."
  value       = tls_private_key.this.public_key_openssh
}