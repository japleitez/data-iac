# data_collection terraform module

IaC for Data Collection of WIHP

##Start/Stop resources on demand

The following jobs can run after a VPC and dashboard modules are up and are manual in all environments

Storm is: zookeeper, storm_cloudwatch, storm cluster (nimbus, supervisors, ui)
MWAA is Apache Airflow

Example 1: If you want to deploy mwaa then run build-mwaa and then deploy-mwaa
In case of destroy, simply run destroy-mwaa

Example 2: If you run build and deploy then everything will be deployed

Example 3: If you run destroy-storm twice, the second time it will not destroy anything

__Jobs:__
- build-storm
- build-mwaa
- deploy-storm
- deploy-mwaa
- destroy-storm
- destroy-mwaa


##Development

###Checkov
Install checkov locally
```
pip3 install checkov
```
Run checkov locally
```
checkov -d .
```

###TFlint
Install https://github.com/terraform-linters/tflint  
Run
```
tflint .
```


## Variables

| Variable Name | Type | Required |Description |
|---------------|-------------|-------------|-------------|
|`var_name`|`string`|Yes|Example variable required by the Terraform module.|

## Usage

### Reference to branch

```
module "data_collection" {
  source = "git::https://git.fpfis.eu/datateam/ecdp-infra/data_collection.git//?ref=master"
}
```

### Reference to version tag

```
module "data_collection" {
  source = "git::https://git.fpfis.eu/datateam/ecdp-infra/data_collection.git//?ref=0.0.1"
}
```


### Restore Acquisition Metadata from snapshot

Acquisition Metadata can be restored on the "Deploy" step. To switch restoring process, the snapshot name  
must be set. The snapshot name is defined in the `TF_VAR_db_snapshot_identifier` variable, in the  Run pipeline/Variables section of CI/CD Job.  

The snapshot should correspond to the related sources (db).  


### Create Acquisition Metadata from snapshot manually

Snapshots for the Acquisition Metadata are created automatically every day.  

Acquisition Metadata snapshot can be created  on the "create-snapshot" manual job.  
The source identifier `DB_INSTANCE_IDENTIFIER` and snapshot name `TF_VAR_db_snapshot_identifier` must be defined in the Run pipeline/Variables section of CI/CD Job.
`DB_INSTANCE_IDENTIFIER` - DB identifier (see in RDS/Databases  AWS rds )   
`TF_VAR_db_snapshot_identifier` - the snapshot name (supported symbols [0-9][a-zA-Z]- ). recommended name : `"source identifier"-sn-"environment"-time_stamp"`


### Delete Acquisition Metadata  manually

Acquisition Metadata instance can be deleted  on the "delete-db-instance" manual job.  
The source identifier `DB_INSTANCE_IDENTIFIER` must be set in the Run pipeline/Variables section of CI/CD Job.  
This job is not available for the `prod`


## Outputs
| Output Name | Description |
|---------------|-------------|
|`output_name`|Example output produced by the Terraform module.|



## Dashboard module

### PostgreSQL configuration

### DB passwords  

DB passwords are stored in the CI/CD Variables :

```
TF_VAR_postgres_secret_development  
TF_VAR_postgres_secret_mr  
TF_VAR_postgres_secret_test  
TF_VAR_postgres_secret_pre  
TF_VAR_postgres_secret_prod  
```

New passwords should be generated each 3 month with  proper tools ( like https://passwordsgenerator.net)  
Password should follow the conditions:   
> Password Length: 16  
> Include Symbols:( e.g. @#$% )  
> Include Numbers:( e.g. 123456 )  
> Include Lowercase Characters:( e.g. abcdefgh )  
> Include Uppercase Characters:( e.g. ABCDEFGH )  
> Exclude Similar Characters:( e.g. i, l, 1, L, o, 0, O )  
> Exclude Ambiguous Characters:( { } [ ] ( ) / \ ' " ` ~ , ; : . < > )  


__Reminders__ for the security updates can be set on this page : https://citnet.tech.ec.europa.eu/CITnet/confluence/display/WIH/Security+reminders   

### PostgreSQL (AWS DB Instance) options per environment

Listed options are defined in the `dashboard/vars.tf` file, in the module `Dashboard`

__instance_class__  - DB instance class types
```
    mr, development, test = "db.t3.micro"
    pre, prod             = "db.t3.small"
```

__allocated_storage__  - amount of storage in gibibytes (GiB)
```
    mr, development, test = 20
    pre, prod             = 50
```

__storage_encrypted__ - Specifies whether the DB instance is encrypted
```
    mr, development, test = false
    pre, prod             = true
```

__multi_az__ - 
```
    mr, development, test = false
    pre, prod             = true
```

__storage_type__ - The storage type
```
    mr, development, test, pre, prod  = "standard"
```
for the `prod`  can be set as `gp2` ( SSD )  

__skip_final_snapshot__ - Determines whether a final DB snapshot is created before the DB instance is deleted
```
    mr, development, test = true
    pre, prod             = false
```
if `skip_final_snapshot` is _false_, then `final_snapshot_identifier` must be provided. 

__final_snapshot_identifier__ - The name of the final DB snapshot when this DB instance is deleted  
`final_snapshot_identifier` defined as DB name + "-backup-" + timestamp

__backup_retention_period__ - The number of days to retain automated PostgreSQL DB backups
```
    mr, development = 0
    test            = 7
    pre, prod       = 1
```

__backup_window__ - The daily time range during which automated backups are created (  >= 30 minutes)
```
    mr          = "20:01-20:43"
    development = "21:01-21:43"
    test        = "22:01-22:43"
    pre         = "23:01-23:43"
    prod        = "23:01-23:43"
```


### Services deployment with tag variables

Dashboard services are deployed using the `deploy-services` manual job. The `build-services` job should succeed before.  

Tags for the deployed services "Data Acquisition Dashboard" , "Data Acquisition Service" and "Playground Service"  
are defined in the `vars.tf` file, in the variables :
```
 data_acquisition_dashboard_tag
 data_acquisition_service_tag 
 playground_service_tag
```

File `vars.tf` is located __in the root__ of the "Data Collection IaC" project.  

Only tag name should be defined in the variabls like :
```
...
variable "playground_service_tag" {
    description = "Tag name for the Playground Service' Docker image"
    default     = "2.0.4"
}
...
```


## Backup and restore elastic (acquisition) data

### Backup elastic (acquisition) data

AWS provides automatic backup of the elastic data. Snapshots files are created each hour.

List of snapshots and corresponded indexes can be extracted with 'elastic-snapshots' job. This job is depend on the _**deploy-services**_ job
and can be launched only if the _**deployed-services**_ job was previously successfully lunched.
The  _**elastic-snapshots**_ job generates a list of snapshots and corresponding indexes in the .json file.
This file can be downloaded from the '**Job artifacts**' section.

JSON file contains the following snapshot's information:
```
{
	"snapshots": [
	{
        "snapshot": "2022-04-28t00-43-27.3dcf5ea2-5f69-4236-8f95-234437a7a3f4",
        "uuid": "EsIoaM08Qbqp6h6H-RzJ_Q",
        "version_id": 7100299,
        "version": "7.10.2",
        "indices": [
            "metrics_2e049f3e-b8be-41c5-9608-642203281130_1256",
            "config_2e049f3e-b8be-41c5-9608-642203281130_1256"
            "content_2e049f3e-b8be-41c5-9608-642203301300_1260",
            ...
        ]
        ...
    },
    {
        "snapshot": "2022-04-28t01-43-23.9e4c0181-6954-4047-8982-cd6f03fe6686",
        "uuid": "Q5KHaIlQREyXBssh9r4C5Q",
        "version_id": 7100299,
        "version": "7.10.2",
        "indices": [
            "metrics_2e049f3e-b8be-41c5-9608-642203281130_1256",
            "config_2e049f3e-b8be-41c5-9608-642203281130_1256"
            "content_2e049f3e-b8be-41c5-9608-642203301300_1260",
            ...
        ]
        ...
    }
  ]
}
```

### Restore elastic (acquisition) data

Each backuped elastic index can be restored from stored snapshot with _**elastic-restore-snapshot**_ job.
This job is depend on the _**deploy-services**_ job and can be launched only if _**deployed-services**_ job was previously successfully lunched.

The 'elastic-restore-snapshot' job requires two parameters:  
`ELK_SNAPSHOT_ID` - the id of the elastic snapshot to restore  
`ELK_INDEX_ID` - the id of the elastic index to restore

`ELK_SNAPSHOT_ID` should be taken from the JSON file on **Backup elastic (acquisition) data** step, from  "snapshot" field :

```
...
"snapshot": "2022-04-28t00-43-27.3dcf5ea2-5f69-4236-8f95-234437a7a3f4",
...
```

`ELK_INDEX_ID` - is part of the index name, which is stored in the JSON file on **Backup elastic (acquisition) data** step, from  "indices" field :
```
"indices": [
    "metrics_2e049f3e-b8be-41c5-9608-642203281130_1256",
    "config_2e049f3e-b8be-41c5-9608-642203281130_1256"
```
in this case `ELK_INDEX_ID` is `2e049f3e-b8be-41c5-9608-642203281130_1256`.  
Then all indexes related to the `2e049f3e-b8be-41c5-9608-642203281130_1256` and snapshot `2022-04-28t00-43-27.3dcf5ea2-5f69-4236-8f95-234437a7a3f4`
will be restored :
```
metrics_2e049f3e-b8be-41c5-9608-642203281130_1256  
config_2e049f3e-b8be-41c5-9608-642203281130_1256
status_2e049f3e-b8be-41c5-9608-642203281130_1256
content_2e049f3e-b8be-41c5-9608-642203281130_1256
```

If a recreated index with the same name already exists in the ELK, this index should first be removed from the ELK.

---
Copyright © 2021, Evangelos Sinapidis - Eurostat
