targetScope = 'managementGroup'

param subscriptionId string

param principalType string

param roleDefinitionId string

param principalId string

module roleAssignmentsCreation 'roles.bicep' = {
  name: 'roleDeployment'
  scope: subscription(subscriptionId)
  params: {
    principalId:principalId
    principalType:principalType
    roleDefinitionId:roleDefinitionId
  }
}
