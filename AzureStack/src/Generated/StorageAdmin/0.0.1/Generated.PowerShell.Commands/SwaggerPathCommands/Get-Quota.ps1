<#
.DESCRIPTION
    Get a list of quotas for this location

.PARAMETER QuotaName
    The name of the quota.

.PARAMETER Location
    Location of storage accounts.

#>
function Get-Quota
{
    [OutputType([Microsoft.AzureStack.Storage.Admin.Models.StorageQuotaModel])]
    [CmdletBinding(DefaultParameterSetName='Quotas_List')]
    param(    
        [Parameter(Mandatory = $true, ParameterSetName = 'Quotas_Get')]
        [System.String]
        $QuotaName,
    
        [Parameter(Mandatory = $true, ParameterSetName = 'Quotas_Get')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Quotas_List')]
        [System.String]
        $Location
    )

    Begin 
    {
	    PSSwagger.Azure.Helpers\Initialize-PSSwaggerDependencies
	}

    Process {
    
    $ErrorActionPreference = 'Stop'
    $serviceCredentials = PSSwagger.Azure.Helpers\Get-AzServiceCredential
    $subscriptionId = Get-AzSubscriptionId
    
    $delegatingHandler = New-Object -TypeName System.Net.Http.DelegatingHandler[] 0

    $StorageAdminClient = New-Object -TypeName Microsoft.AzureStack.Storage.Admin.StorageAdminClient -ArgumentList $serviceCredentials,$delegatingHandler
    $ResourceManagerUrl = PSSwagger.Azure.Helpers\Get-AzResourceManagerUrl
    $StorageAdminClient.BaseUri = $ResourceManagerUrl
    
    if(Get-Member -InputObject $StorageAdminClient -Name 'SubscriptionId' -MemberType Property)
    {
        $StorageAdminClient.SubscriptionId = $subscriptionId
    }
    
    

    $skippedCount = 0
    $returnedCount = 0
    if ('Quotas_Get' -eq $PsCmdlet.ParameterSetName) {
        Write-Verbose -Message 'Performing operation GetWithHttpMessagesAsync on $StorageAdminClient.'
        $taskResult = $StorageAdminClient.Quotas.GetWithHttpMessagesAsync($Location, $QuotaName)
    } elseif ('Quotas_List' -eq $PsCmdlet.ParameterSetName ) {
        Write-Verbose -Message 'Performing operation ListWithHttpMessagesAsync on $StorageAdminClient.'
        $taskResult = $StorageAdminClient.Quotas.ListWithHttpMessagesAsync($Location)
    } else {
        Write-Verbose -Message 'Failed to map parameter set to operation method.'
        throw 'Module failed to find operation to execute.'
    }

    if ($TaskResult) {
        $result = $null
        $ErrorActionPreference = 'Stop'
                    
        $null = $taskResult.AsyncWaitHandle.WaitOne()
                    
        Write-Debug -Message "$($taskResult | Out-String)"

        if($taskResult.IsFaulted)
        {
            Write-Verbose -Message 'Operation failed.'
            Throw "$($taskResult.Exception.InnerExceptions | Out-String)"
        } 
        elseif ($taskResult.IsCanceled)
        {
            Write-Verbose -Message 'Operation got cancelled.'
            Throw 'Operation got cancelled.'
        }
        else
        {
            Write-Verbose -Message 'Operation completed successfully.'

            if($taskResult.Result -and
                (Get-Member -InputObject $taskResult.Result -Name 'Body') -and
                $taskResult.Result.Body)
            {
                $result = $taskResult.Result.Body
                Write-Debug -Message "$($result | Out-String)"
                $result
            }
        }
        
    }
    }
}
