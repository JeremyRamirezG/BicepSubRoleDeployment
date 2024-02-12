targetScope = 'managementGroup'

//This parameter is used in the deployment to determine if a new subscription should be created.
param subscriptionDeployment bool

@description('Provide a name for the alias. This name will also be the display name of the subscription.')
param subscriptionAliasName string

@description('Provide the full resource ID of billing scope to use for subscription creation.')
param billingScope string

param subWorload string

//Roles parameters
@description('Principal type.')
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string

@description('Use the following documentation to get the needed role definition ID: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles')
param roleDefinitionId string

@description('The principal who will get permissions.')
param principalId string


resource subscriptionAlias 'Microsoft.Subscription/aliases@2020-09-01' = if (subscriptionDeployment) {
  scope: tenant()
  name: subscriptionAliasName
  properties: {
    workload: subWorload
    displayName: subscriptionAliasName
    billingScope: billingScope
  }
}

resource subscriptionExisting 'Microsoft.Subscription/aliases@2020-09-01' existing = if (!subscriptionDeployment) {
  name: subscriptionAliasName
  scope: tenant()
}

module subscriptionReference 'subscriptionReference.bicep' = {
  name: 'subscriptionReference'
  scope: managementGroup()
  params:{
    subscriptionId: subscriptionDeployment ? subscriptionAlias.properties.subscriptionId : subscriptionExisting.properties.subscriptionId
    principalId:principalId
    roleDefinitionId:roleDefinitionId
    principalType:principalType
  }
}
