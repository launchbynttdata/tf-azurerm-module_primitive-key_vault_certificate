// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

output "name" {
  description = "The name of the certificate"
  value       = azurerm_key_vault_certificate.certificate.name
}

output "thumbprint" {
  description = "The thumbprint of the certificate"
  value       = azurerm_key_vault_certificate.certificate.thumbprint
}

output "version" {
  description = "The current version of the certificate"
  value       = azurerm_key_vault_certificate.certificate.version
}

# e.g. https://example.vault.azure.net/certificates/example-certificate/f65bad370a78445687be08cb4b5d20b2
output "id" {
  description = "The ID of the Key Vault Certificate"
  value       = azurerm_key_vault_certificate.certificate.id
}

# e.g. https://example.vault.azure.net/certificates/example-certificate (not pinned to specific version)
output "versionless_id" {
  description = "The ID of the Key Vault Certificate without the current version"
  value       = azurerm_key_vault_certificate.certificate.versionless_id
}

# e.g. https://example.vault.azure.net/secrets/example-certificate/f65bad370a78445687be08cb4b5d20b2
output "secret_id" {
  description = "id of the underlying secret with the current version"
  value       = azurerm_key_vault_certificate.certificate.secret_id
}

# e.g. https://example.vault.azure.net/secrets/example-certificate (not pinned to specific version)
output "versionless_secret_id" {
  description = "id of the underlying secret without the current version"
  value       = azurerm_key_vault_certificate.certificate.versionless_secret_id
}

output "resource_manager_id" {
  description = "The Resource Manager ID of the Key Vault Certificate"
  value       = azurerm_key_vault_certificate.certificate.resource_manager_id
}

output "resource_manager_versionless_id" {
  description = "The Resource Manager ID of the Key Vault Certificate without the current version"
  value       = azurerm_key_vault_certificate.certificate.resource_manager_versionless_id
}
