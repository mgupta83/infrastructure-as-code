param mongoDatabaseAccountName string
param mongoDatabaseName string
param maxThroughput int

resource mongoDatabaseAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: mongoDatabaseAccountName
}
resource mongoDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2022-08-15' = {
  parent: mongoDatabaseAccount
  name: mongoDatabaseName
  properties: {
    resource: {
      id: mongoDatabaseName
    }
  }
  dependsOn: [
    mongoDatabaseAccount
  ]
}

resource mongoDatabaseThroughputSettingsAutoscale 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/throughputSettings@2022-08-15' = {
  parent: mongoDatabase
  name: 'default'
  properties: {
    resource: {
      // throughput: 100
      autoscaleSettings: {
        maxThroughput: maxThroughput
      }
    }
  }
  dependsOn: [
    mongoDatabase
  ]
}
