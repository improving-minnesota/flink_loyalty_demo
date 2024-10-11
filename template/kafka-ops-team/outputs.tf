output "staging-resource-ids" {
  value = <<-EOT

  ====

  Staging Environment ID:   ${module.staging_environment.id}
  Staging EnvironmentAdmin/AccountAdmin API Key:  ${module.staging_environment.env_admin_api_key.id}:${module.staging_environment.env_admin_api_key.secret}

  EOT

  sensitive = true
}
