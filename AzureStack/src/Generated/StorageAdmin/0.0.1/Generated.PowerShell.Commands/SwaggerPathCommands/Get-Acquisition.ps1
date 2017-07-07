<#
.DESCRIPTION
    Get a list of acquistions

.PARAMETER AcquisitionId
    TODO

.PARAMETER Filter
    TODO

.PARAMETER ResourceGroupName
    The name of the resource group within the user's subscription.

.PARAMETER FarmId
    Th name of the farm.

#>
function Get-Acquisition
{
    [OutputType([Microsoft.AzureStack.Storage.Admin.Models.AcquisitionModel])]
    [CmdletBinding(DefaultParameterSetName='Acquisitions_List')]
    param(    
        [Parameter(Mandatory = $true, ParameterSetName = 'Acquisitions_Get')]
        [System.String]
        $AcquisitionId,
    
        [Parameter(Mandatory = $true, ParameterSetName = 'Acquisitions_List')]
        [System.String]
        $Filter,
    
        [Parameter(Mandatory = $true, ParameterSetName = 'Acquisitions_Get')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Acquisitions_List')]
        [System.String]
        $ResourceGroupName,
    
        [Parameter(Mandatory = $true, ParameterSetName = 'Acquisitions_Get')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Acquisitions_List')]
        [System.String]
        $FarmId
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
    
    if(Get-Member -InputObject $StorageAdminClient -Name 'AcquisitionId' -MemberType Property)
    {
        $StorageAdminClient.AcquisitionId = $AcquisitionId
    }
    if(Get-Member -InputObject $StorageAdminClient -Name 'SubscriptionId' -MemberType Property)
    {
        $StorageAdminClient.SubscriptionId = $subscriptionId
    }
    
    

    $skippedCount = 0
    $returnedCount = 0
    if ('Acquisitions_Get' -eq $PsCmdlet.ParameterSetName) {
        Write-Verbose -Message 'Performing operation GetWithHttpMessagesAsync on $StorageAdminClient.'
        $taskResult = $StorageAdminClient.Acquisitions.GetWithHttpMessagesAsync($ResourceGroupName, $FarmId)
    } elseif ('Acquisitions_List' -eq $PsCmdlet.ParameterSetName ) {
        Write-Verbose -Message 'Performing operation ListWithHttpMessagesAsync on $StorageAdminClient.'
        $taskResult = $StorageAdminClient.Acquisitions.ListWithHttpMessagesAsync($ResourceGroupName, $FarmId, $Filter)
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
