// params
@allowed([
  'prod'
  'uat'
  'qa'
  'dev'
])
param environment string

// variables
var resourceGroupLocation = resourceGroup().location

// Read Parameters files
var envParamFile = loadJsonContent('./env.parameters.json')
var envParams = envParamFile[environment]
var appParams = loadJsonContent('./app.parameters.json')

// Resource Names
module resourceNames './resource-names.bicep' = {
  name: 'resourceNamesModule'
  params: {
    environment: environment
    applicationPrefix: appParams.applicationPrefix
  }
}
var mongoDatabaseAccountName = resourceNames.outputs.mongoDatabaseAccountName
var mongoDatabaseName = resourceNames.outputs.mongoDatabaseName


// Add Modules Here
module mongoDatabaseAccount './modules/mongo-database-account.bicep' = {
  name: 'mongoDatabaseAccountModule'
  params: {
    location: envParams.mongoDatabaseAccount.location ?? resourceGroupLocation
    mongoDatabaseAccountName: mongoDatabaseAccountName
    totalThroughputLimit: envParams.mongoDatabaseAccount.totalThroughputLimit
    backupIntervalInMinutes: envParams.mongoDatabaseAccount.backupIntervalInMinutes
    backupRetentionIntervalInHours: envParams.mongoDatabaseAccount.backupRetentionIntervalInHours
  }
}

module mongoDatabase './modules/mongo-database.bicep' = {
  name: 'mongoDatabaseModule'
  params: {
    mongoDatabaseAccountName: mongoDatabaseAccountName
    mongoDatabaseName: mongoDatabaseName
    maxThroughput: envParams.mongoDatabaseThroughputSettingsAutoscale.maxThroughput
  }
}
