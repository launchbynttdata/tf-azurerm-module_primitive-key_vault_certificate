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

resource "azurerm_key_vault_certificate" "certificate" {
  name         = var.name
  key_vault_id = var.key_vault_id

  dynamic "certificate" {
    for_each = var.method == "Import" ? [var.certificate] : []
    content {
      contents = var.certificate.contents
      password = var.certificate.password
    }
  }

  dynamic "certificate_policy" {
    for_each = var.method == "Generate" ? [var.issuer_name] : []
    content {
      issuer_parameters {
        name = var.issuer_name
      }
      key_properties {
        exportable = var.key_properties.exportable
        key_type   = var.key_properties.key_type
        reuse_key  = var.key_properties.reuse_key
        curve      = var.key_properties.curve
        key_size   = var.key_properties.key_size
      }
      secret_properties {
        content_type = var.secret_properties.content_type
      }
      dynamic "lifetime_action" {
        for_each = var.lifetime_action != null ? [var.lifetime_action] : []
        content {
          action {
            action_type = var.lifetime_action.action.action_type
          }
          trigger {
            days_before_expiry  = var.lifetime_action.trigger.days_before_expiry
            lifetime_percentage = var.lifetime_action.trigger.lifetime_percentage
          }
        }
      }
      dynamic "x509_certificate_properties" {
        for_each = var.x509_certificate_properties != null ? [var.x509_certificate_properties] : []
        content {
          key_usage          = var.x509_certificate_properties.key_usage
          validity_in_months = var.x509_certificate_properties.validity_in_months
          subject            = var.x509_certificate_properties.subject
          extended_key_usage = var.x509_certificate_properties.extended_key_usage

          dynamic "subject_alternative_names" {
            for_each = var.x509_certificate_properties.subject_alternative_names != null ? [
              var.x509_certificate_properties.subject_alternative_names
            ] : []
            content {
              dns_names = var.x509_certificate_properties.subject_alternative_names.dns_names
              emails    = var.x509_certificate_properties.subject_alternative_names.emails
              upns      = var.x509_certificate_properties.subject_alternative_names.upns
            }
          }
        }
      }
    }
  }

  tags = var.tags
}
