param databaseAccounts_data_access_qa_name string = 'data-access-qa'

resource databaseAccounts_data_access_qa_name_resource 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: databaseAccounts_data_access_qa_name
  location: 'West US 3'
  tags: {
    defaultExperience: 'Azure Cosmos DB for MongoDB API'
    'hidden-cosmos-mmspecial': ''
  }
  kind: 'MongoDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    enableClientTelemetry: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: true
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'FullFidelity'
    }
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    enablePartitionMerge: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    configurationOverrides: {
      EnableBsonSchema: 'True'
    }
    apiProperties: {
      serverVersion: '4.2'
    }
    locations: [
      {
        locationName: 'West US 3'
        // provisioningState: 'Succeeded'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: [
      {
        name: 'EnableMongo'
      }
      {
        name: 'DisableRateLimitingResponses'
      }
    ]
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 96
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    capacity: {
      totalThroughputLimit: 3200
    }
    // keysMetadata: {
    // }
  }
}

resource databaseAccounts_data_access_qa_name_efm_qa 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2022-08-15' = {
  parent: databaseAccounts_data_access_qa_name_resource
  name: 'efm-qa'
  properties: {
    resource: {
      id: 'efm-qa'
    }
  }
}

resource databaseAccounts_data_access_qa_name_efm_qa_applicants 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2022-08-15' = {
  parent: databaseAccounts_data_access_qa_name_efm_qa
  name: 'applicants'
  properties: {
    resource: {
      id: 'applicants'
      indexes: [
        {
          key: {
            keys: [
              '_id'
            ]
          }
        }
      ]
    }
  }
  dependsOn: [

    databaseAccounts_data_access_qa_name_resource
  ]
}

resource databaseAccounts_data_access_qa_name_efm_qa_default 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/throughputSettings@2022-08-15' = {
  parent: databaseAccounts_data_access_qa_name_efm_qa
  name: 'default'
  properties: {
    resource: {
      // throughput: 100
      autoscaleSettings: {
        maxThroughput: 1000
      }
    }
  }
  dependsOn: [

    databaseAccounts_data_access_qa_name_resource
  ]
}
