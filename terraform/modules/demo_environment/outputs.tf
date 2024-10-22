output "env_id" {
  description = "ID of the Confluent Cloud Environment that was created."
  value       = confluent_environment.this.id
}

output "env_name" {
  description = "The full Confluent Environment resource that was created."
  value       = confluent_environment.this.display_name
}

output "env_email" {
  description = "The email of the Environment Admin."
  value = var.cc_user_email
}