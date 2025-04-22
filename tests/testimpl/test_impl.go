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

package common

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestComposableKeyVaultSecret(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	rgName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
	keyVaultName := terraform.Output(t, ctx.TerratestTerraformOptions(), "key_vault_name")
	certificateName := terraform.Output(t, ctx.TerratestTerraformOptions(), "certificate_name")

	t.Run("KeyVaultExists", func(t *testing.T) {
		keyVault := azure.GetKeyVault(t, rgName, keyVaultName, subscriptionId)
		assert.Equal(t, keyVaultName, *keyVault.Name, "Expected Key Vault name to be %s, but got %s", keyVaultName, *keyVault.Name)
	})

	t.Run("SecretExists", func(t *testing.T) {
		secretExists := azure.KeyVaultCertificateExists(t, keyVaultName, certificateName)
		assert.True(t, secretExists, "Expected secret %s to exist in Key Vault %s, but it does not", certificateName, keyVaultName)
	})
}
