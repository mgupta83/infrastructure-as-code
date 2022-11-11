param environment string
param applicationPrefix string


output mongoDatabaseAccountName string = 'data-access-${applicationPrefix}-${environment}'
output mongoDatabaseName string = '${applicationPrefix}-${environment}'
