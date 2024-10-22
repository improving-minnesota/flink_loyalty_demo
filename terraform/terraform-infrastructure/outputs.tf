output "environments" {
    value       = [
    for e in module.demo_environment : "${e.env_id} : ${e.env_email} - ${e.env_name}"
  ]
}