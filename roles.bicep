targetScope = 'subscription'

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

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: roleDefinitionId
}

resource symbolicname 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, roleDefinitionId, principalId)
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: roleDefinition.id
  }
}
