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

product_family  = "dso"
product_service = "test"

tags = {
  Purpose = "Terratest"
}

certificate_name = "test-certificate"

issuer_name = "Self"

lifetime_action = {
  action = {
    action_type = "AutoRenew"
  }
  trigger = {
    days_before_expiry = 90
  }
}

x509_certificate_properties = {
  key_usage          = ["digitalSignature", "nonRepudiation", "keyCertSign", "keyEncipherment", "dataEncipherment"]
  subject            = "CN=Launch DSO Test Certificate"
  validity_in_months = 12
  subject_alternate_names = {
    emails    = ["test@launchdso.nttdata.com"]
    dns_names = ["launchdso.nttdata.com"]
  }
}
