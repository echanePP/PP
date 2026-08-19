if(empty(body('Filter_OwnerRole')), 'Full Control (assumed)', join(select(first(body('Filter_OwnerRole'))?['RoleDefinitionBindings']?['results'], item()?['Name']), ', '))
