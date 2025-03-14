# tf-azurerm-module_primitive-key_vault_certificate

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform module creates a `key vault` in `azure` cloud provider. The module is designed to be used as a `primitive` in a `collection` or `reference architecture` module.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
  footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.67 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_certificate.certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the certificate | `string` | n/a | yes |
| <a name="input_method"></a> [method](#input\_method) | Method of certificate creation. Possible values are 'Import' and 'Generate' | `string` | n/a | yes |
| <a name="input_certificate"></a> [certificate](#input\_certificate) | base64-encoded pfx bundle containing the certificate, with optional password | <pre>object({<br>    contents = string<br>    password = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_issuer_name"></a> [issuer\_name](#input\_issuer\_name) | name of the issuer to generate the certificate with. Use 'Self' for self-signed certificate | `string` | `"Self"` | no |
| <a name="input_key_properties"></a> [key\_properties](#input\_key\_properties) | options for the private key of the certificate | <pre>object({<br>    exportable = bool<br>    key_type   = string<br>    reuse_key  = bool<br>    curve      = optional(string)<br>    key_size   = optional(number)<br>  })</pre> | <pre>{<br>  "exportable": true,<br>  "key_size": 2048,<br>  "key_type": "RSA",<br>  "reuse_key": false<br>}</pre> | no |
| <a name="input_lifetime_action"></a> [lifetime\_action](#input\_lifetime\_action) | action to take when the certificate is about to expire | <pre>object({<br>    action = object({<br>      action_type = string<br>    })<br>    trigger = object({<br>      days_before_expiry  = optional(number)<br>      lifetime_percentage = optional(number)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_secret_properties"></a> [secret\_properties](#input\_secret\_properties) | properties of the underlying key vault secret | <pre>object({<br>    content_type = string<br>  })</pre> | <pre>{<br>  "content_type": "application/x-pkcs12"<br>}</pre> | no |
| <a name="input_x509_certificate_properties"></a> [x509\_certificate\_properties](#input\_x509\_certificate\_properties) | properties of the x509 certificate | <pre>object({<br>    key_usage          = list(string)<br>    extended_key_usage = optional(list(string))<br>    subject            = string<br>    validity_in_months = number<br>    subject_alternative_names = optional(object({<br>      dns_names = optional(list(string))<br>      emails    = optional(list(string))<br>      upns      = optional(list(string))<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags for the certificate | `map(string)` | `{}` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Id of the key vault to which certificates need to be added. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The name of the certificate |
| <a name="output_thumbprint"></a> [thumbprint](#output\_thumbprint) | The thumbprint of the certificate |
| <a name="output_version"></a> [version](#output\_version) | The current version of the certificate |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Key Vault Certificate |
| <a name="output_versionless_id"></a> [versionless\_id](#output\_versionless\_id) | The ID of the Key Vault Certificate without the current version |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | id of the underlying secret with the current version |
| <a name="output_versionless_secret_id"></a> [versionless\_secret\_id](#output\_versionless\_secret\_id) | id of the underlying secret without the current version |
| <a name="output_resource_manager_id"></a> [resource\_manager\_id](#output\_resource\_manager\_id) | The Resource Manager ID of the Key Vault Certificate |
| <a name="output_resource_manager_versionless_id"></a> [resource\_manager\_versionless\_id](#output\_resource\_manager\_versionless\_id) | The Resource Manager ID of the Key Vault Certificate without the current version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
