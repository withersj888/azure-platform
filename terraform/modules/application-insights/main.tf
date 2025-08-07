# Application Insights Module - Main Configuration

# Log Analytics Workspace for Application Insights
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-${var.environment}-law-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Application Insights instance
resource "azurerm_application_insights" "main" {
  name                = "${var.project_name}-${var.environment}-ai-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"

  tags = var.tags
}

# Action Group for alerts
resource "azurerm_monitor_action_group" "main" {
  name                = "${var.project_name}-${var.environment}-ag-${var.suffix}"
  resource_group_name = var.resource_group_name
  short_name          = "azplatform"

  tags = var.tags
}

# Sample metric alert for Application Insights
resource "azurerm_monitor_metric_alert" "failed_requests" {
  name                = "${var.project_name}-${var.environment}-failed-requests-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when failed request rate is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Sample availability test
resource "azurerm_application_insights_web_test" "main" {
  name                    = "${var.project_name}-${var.environment}-webtest-${var.suffix}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = azurerm_application_insights.main.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 60
  enabled                 = true
  geo_locations           = ["us-ca-sjc-azr", "us-tx-sn1-azr", "us-il-ch1-azr"]

  configuration = <<XML
<WebTest Name="WebTest1" Id="ABD48585-0831-40CB-9069-682EA6BB3583" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="a5f10126-e4cd-570d-961c-cea43999a200" Version="1.1" Url="http://microsoft.com" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML

  tags = var.tags
}