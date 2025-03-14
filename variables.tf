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

variable "name" {
  type        = string
  description = "The name of the certificate"
}

variable "method" {
  type        = string
  description = "Method of certificate creation. Possible values are 'Import' and 'Generate'"

  validation {
    condition     = can(index(["Import", "Generate"], var.method))
    error_message = "method must be either 'Import' or 'Generate'"
  }
}

# import an existing certificate
variable "certificate" {
  description = "base64-encoded pfx bundle containing the certificate, with optional password"
  type = object({
    contents = string
    password = optional(string)
  })
  default = null
  validation {
    condition     = var.certificate == null || can(regex("^[a-zA-Z0-9+/=]+$", var.certificate.contents))
    error_message = "the certificate data must be a valid base64 encoded string"
  }
}

# generate a new certificate
variable "issuer_name" {
  description = "name of the issuer to generate the certificate with. Use 'Self' for self-signed certificate"
  type        = string
  default     = "Self"
}

variable "key_properties" {
  description = "options for the private key of the certificate"
  type = object({
    exportable = bool
    key_type   = string
    reuse_key  = bool
    curve      = optional(string)
    key_size   = optional(number)
  })
  default = {
    exportable = true
    key_type   = "RSA"
    key_size   = 2048
    reuse_key  = false
  }

  validation {
    condition     = can(index(["EC", "EC-HSM", "RSA", "RSA-HSM", "oct"], var.key_properties.key_type))
    error_message = "key_type must be one of 'EC', 'EC-HSM', 'RSA', 'RSA-HSM', or 'oct'"
  }

  validation {
    condition = (
      # the key_type is eliptic curve and the curve is one of the supported curves
      can(index(["EC", "EC-HSM"], var.key_properties.key_type))
      && can(index(["P-256", "P-256K", "P-384", "P-521"], var.key_properties.curve))
      ) || (
      # the key_type is not an eliptic curve
      can(index(["RSA", "RSA-HSM", "oct"], var.key_properties.key_type))
    )
    error_message = "curve must be one of 'P-256', 'P-256K', 'P-384', or 'P-521' for EC keys"
  }

  validation {
    condition = (
      # the key_type is RSA and the key_size is one of the supported sizes
      can(index(["RSA", "RSA-HSM", "oct"], var.key_properties.key_type))
      && can(index([2048, 3072, 4096], var.key_properties.key_size))
      ) || (
      # the key_type not RSA
      can(index(["EC", "EC-HSM"], var.key_properties.key_type))
    )
    error_message = "key_size must be one of 2048, 3072, or 4096 for RSA keys"
  }
}

variable "lifetime_action" {
  description = "action to take when the certificate is about to expire"
  type = object({
    action = object({
      action_type = string
    })
    trigger = object({
      days_before_expiry  = optional(number)
      lifetime_percentage = optional(number)
    })
  })
  default = null

  validation {
    condition = var.lifetime_action == null || (
      can(index(["AutoRenew", "EmailContacts"], var.lifetime_action.action.action_type))
    )
    error_message = "action_type must be one of 'AutoRenew' or 'EmailContacts'"
  }

  validation {
    condition = var.lifetime_action == null || (
      try(var.lifetime_action.trigger.days_before_expiry, null) != null
      || try(var.lifetime_action.trigger.lifetime_percentage, null) != null
    )
    error_message = "one of days_before_expiry or lifetime_percentage must be set"
  }
}

variable "secret_properties" {
  description = "properties of the underlying key vault secret"
  type = object({
    content_type = string
  })
  default = {
    content_type = "application/x-pkcs12"
  }

  validation {
    condition     = can(index(["application/x-pkcs12", "application/x-pem-file"], var.secret_properties.content_type))
    error_message = "content_type must be one of 'application/x-pkcs12' or 'application/x-pem-file'"
  }
}

variable "x509_certificate_properties" {
  description = "properties of the x509 certificate"
  type = object({
    key_usage          = list(string)
    extended_key_usage = optional(list(string))
    subject            = string
    validity_in_months = number
    subject_alternative_names = optional(object({
      dns_names = optional(list(string))
      emails    = optional(list(string))
      upns      = optional(list(string))
    }))
  })
  default = null

  validation {
    condition = var.x509_certificate_properties == null || (
      alltrue([
        for k in try(var.x509_certificate_properties.key_usage, [""]) : can(index(["digitalSignature", "nonRepudiation", "keyEncipherment", "dataEncipherment", "keyAgreement", "keyCertSign", "cRLSign", "encipherOnly", "decipherOnly"], k))
      ])
    )
    error_message = "key_usage must be a list of valid key usages"
  }
}

variable "tags" {
  type        = map(string)
  description = "The tags for the certificate"
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "Id of the key vault to which certificates need to be added."
}
