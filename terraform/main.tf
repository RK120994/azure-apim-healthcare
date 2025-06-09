provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "Developer_1"
  identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = "dev"
    project     = "healthcare-apim"
  }
}

resource "azurerm_api_management_api" "fhir" {
  name                = "fhir-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "FHIR API"
  path                = "fhir"
  protocols           = ["https"]
  import {
    content_format = "openapi"
    content_value  = file("../apis/fhir-api.yaml")
  }
}

resource "azurerm_api_management_api_policy" "jwt_policy" {
  api_name            = azurerm_api_management_api.fhir.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <validate-jwt header-name="Authorization" require-scheme="Bearer">
      <openid-config url="https://login.microsoftonline.com/${var.tenant_id}/v2.0/.well-known/openid-configuration" />
      <required-claims>
        <claim name="aud">
          <value>${var.api_audience}</value>
        </claim>
        <claim name="iss">
          <value>https://sts.windows.net/${var.tenant_id}/</value>
        </claim>
      </required-claims>
    </validate-jwt>
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
</policies>
XML
}
