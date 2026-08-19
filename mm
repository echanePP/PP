if(empty(coalesce(body('Filter_OwnerRole'), json('[]'))), 'Full Control (assumed)', first(first(body('Filter_OwnerRole'))?['RoleDefinitionBindings']?['results'])?['Name'])
