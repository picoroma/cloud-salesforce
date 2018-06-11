
# Salesforce Opspack

Salesforce is a cloud computing company that is one of the leading organizations advocating the shift to socially connected businesses. Their customer relationship management (CRM) tool is their most profitable and recognizable product, but Salesforce also capitalizes on commercial applications of social networking through acquisition. With the Salesforce Opspack, users are able to build more meaningful and lasting relationships and connect with customers across sales, customer service, marketing, communities, apps, and analytics.

## What You Can Monitor 

Opsview Monitor contains all the latest service checks to follow what is happening in your Salesforce environment. The Salesforce Opspack will monitor all of the following checks:

API Requests including bulk, streaming and daily API requests
Hourly dashboard status, results and refreshes
SFDC Report runs, hourly time-based workflow and more 
Business Service Monitoring is a great way to tie dependencies and alerting your critical business systems such as Salesforce. With powerful alerting metrics for hosts required online and allowed to fail, you can make sure your IT team is alerted for the right reasons.

## Service Checks

| Service Check | Description |
|:------------- |:----------- |
| ConcurrentAsyncGetReportInstances | Check Salesforce ConcurrentAsyncGetReportInstances |
| ConcurrentSyncReportRuns | Check Salesforce ConcurrentSyncReportRuns |
| DailyApiRequests | Check Salesforce DailyApiRequests |
| DailyAsyncApexExecutions | Check Salesforce DailyAsyncApexExecutions |
| DailyBulkApiRequests | Check Salesforce DailyBulkApiRequests |
| DailyGenericStreamingApiEvents | Check Salesforce DailyGenericStreamingApiEvents |
| DailyStreamingApiEvents | Check Salesforce DailyStreamingApiEvents |
| DailyWorkflowEmails | Check Salesforce DailyWorkflowEmails |
| DataStorageMB | Check Salesforce DataStorageMB metric |
| FileStorageMB | Check Salesforce FileStorageMB |
| HourlyAsyncReportRuns | Check Salesforce HourlyAsyncReportRuns |
| HourlyDashboardRefreshes |Check Salesforce HourlyDashboardRefreshes |
| HourlyDashboardResults | Check Salesforce HourlyDashboardResults  |
| HourlyDashboardStatuses | Check Salesforce HourlyDashboardStatuses |
| HourlySyncReportRuns | Check Salesforce HourlySyncReportRuns |
| HourlyTimeBasedWorkflow | Check Salesforce HourlyTimeBasedWorkflow |
| MassEmail |Check Salesforce MassEmail |
| SingleEmail | Check Salesforce SingleEmail |
| StreamingApiConcurrentClients | Check Salesforce StreamingApiConcurrentClients |

## Setup and Configuration

To configure and utilize this Opspack, you simply need to add the 'Cloud - Salesforce' Opspack your Opsview Monitor system.

Step 1: Add the host template

![Add host template](/docs/img/add_salesforce_host.png?raw=true)

Step 2: Configure the variables for SALESFORCE_LOGIN and SALESFORCE_AUTH as required

**SALESFORCE_AUTH** - Add this variable to the host. Within this variable you will need to provide a valid SalesForce Token, Client key and Client secret. If you do not have these on hand, please contact your SalesForce administrator.

**SALESFORCE_LOGIN** - Add this variable to the host.  Within this variable you will need to provide a valid SalesForce username and password.

![Add variables](/docs/img/configure_salesforce_variables.png?raw=true)

Step 3: Reload and the system will now be monitored

![View Service Checks](/docs/img/salesforce_service_checks.png?raw=true)
