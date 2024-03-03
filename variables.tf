variable "stage" {
  default = "dev"
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  default     = "TEST"
}

variable "environment" {
  description = "Environment for service"
  default     = "STAGE"
}

variable "tags" {
  description = "A list of tag blocks. Each element should have keys named key, value, etc."
  type        = map(string)
  default     = {}
}

# crawler variables

variable "enable_glue_crawler" {
  description = "Enable glue crawler usage"
  default     = false
}

variable "glue_crawler_name" {
  description = "Name of the crawler."
  default     = ""
}

variable "glue_database_name" {
  description = "Glue database where results are written."
  default     = ""
}

variable "glue_role" {
  description = "(Required) The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources."
  default     = ""
}

variable "glue_crawler_description" {
  description = "(Optional) Description of the crawler."
  default     = null
}

variable "glue_classifiers" {
  description = "(Optional) List of custom classifiers. By default, all AWS classifiers are included in a crawl, but these custom classifiers always override the default classifiers for a given classification."
  default     = null
}

variable "glue_configuration" {
  description = "(Optional) JSON string of configuration information."
  default     = null
}

variable "glue_schedule" {
  description = "(Optional) A cron expression used to specify the schedule. For more information, see Time-Based Schedules for Jobs and Crawlers. For example, to run something every day at 12:15 UTC, you would specify: cron(15 12 * * ? *)."
  default     = null
}

variable "glue_security_configuration" {
  description = "(Optional) The name of Security Configuration to be used by the crawler"
  default     = null
}

variable "glue_table_prefix" {
  description = "(Optional) The table prefix used for catalog tables that are created."
  default     = null
}

variable "glue_dynamodb_target" {
  description = "(Optional) List of nested DynamoDB target arguments."
  default     = []
}

variable "glue_jdbc_target" {
  description = "(Optional) List of nested JBDC target arguments. "
  default     = []
}

variable "glue_s3_target" {
  description = "(Optional) List nested Amazon S3 target arguments."
  default     = []
}

variable "glue_catalog_target" {
  description = "(Optional) List nested Amazon catalog target arguments."
  default     = []
}

variable "glue_schema_change_policy" {
  description = "(Optional) Policy for the crawler's update and deletion behavior."
  default     = []
}

variable "glue_recrawl_policy" {
  description = "Optional) A policy that specifies whether to crawl the entire dataset again, or to crawl only folders that were added since the last crawler run."
  default     = []
}

variable "glue_mongodb_target" {
  description = "(Optional) List nested MongoDB target arguments."
  default     = []
}

variable "glue_lineage_configuration" {
  description = "(Optional) Specifies data lineage configuration settings for the crawler."
  default     = []
}

# glue_catalog variables

variable "enable_glue_catalog_database" {
  description = "Enable glue catalog database usage"
  default     = false
}

variable "glue_catalog_database_name" {
  description = "The name of the database."
  default     = ""
}

variable "glue_catalog_database_description" {
  description = "(Optional) Description of the database."
  default     = null
}

variable "glue_catalog_database_catalog_id" {
  description = "(Optional) ID of the Glue Catalog to create the database in. If omitted, this defaults to the AWS Account ID."
  default     = null
}

variable "glue_catalog_database_location_uri" {
  description = "(Optional) The location of the database (for example, an HDFS path)."
  default     = null
}

variable "glue_catalog_database_parameters" {
  description = "(Optional) A list of key-value pairs that define parameters and properties of the database."
  default     = null
}

# glue_security_configuration variables
variable "enable_glue_security_configuration" {
  description = "Enable glue security configuration usage"
  default     = false
}

variable "glue_security_configuration_name" {
  description = "Name of the security configuration."
  default     = ""
}

variable "glue_security_configuration_encryption_configuration" {
  description = "Set encryption configuration for Glue security configuration"
  default     = {}
}

#glue_catalog_table variables
variable "enable_glue_catalog_table" {
  description = "Enable glue catalog table usage"
  default     = false
}

variable "glue_catalog_table_name" {
  description = "Name of the table. For Hive compatibility, this must be entirely lowercase."
  default     = ""
}

variable "glue_catalog_table_database_name" {
  description = "Name of the metadata database where the table metadata resides. For Hive compatibility, this must be all lowercase."
  default     = ""
}

variable "glue_catalog_table_description" {
  description = "(Optional) Description of the table."
  default     = null
}

variable "glue_catalog_table_catalog_id" {
  description = "(Optional) ID of the Glue Catalog and database to create the table in. If omitted, this defaults to the AWS Account ID plus the database name."
  default     = null
}

variable "glue_catalog_table_owner" {
  description = "(Optional) Owner of the table."
  default     = null
}

variable "glue_catalog_table_retention" {
  description = "(Optional) Retention time for this table."
  default     = null
}

variable "glue_catalog_table_partition_keys" {
  description = "(Optional) A list of columns by which the table is partitioned. Only primitive types are supported as partition keys."
  default     = []
}

variable "glue_catalog_table_view_original_text" {
  description = "(Optional) If the table is a view, the original text of the view; otherwise null."
  default     = null
}

variable "glue_catalog_table_view_expanded_text" {
  description = "(Optional) If the table is a view, the expanded text of the view; otherwise null."
  default     = null
}

variable "glue_catalog_table_table_type" {
  description = "(Optional) The type of this table (EXTERNAL_TABLE, VIRTUAL_VIEW, etc.)."
  default     = null
}

variable "glue_catalog_table_parameters" {
  description = "(Optional) Properties associated with this table, as a list of key-value pairs."
  default     = null
}

variable "glue_catalog_table_storage_descriptor" {
  description = "(Optional) A storage descriptor object containing information about the physical storage of this table. You can refer to the Glue Developer Guide for a full explanation of this object."
  default = {
    location                  = null
    input_format              = null
    output_format             = null
    compressed                = null
    number_of_buckets         = null
    bucket_columns            = null
    parameters                = null
    stored_as_sub_directories = null
  }
}

#glue_connection variables

variable "enable_glue_connection" {
  description = "Enable glue connection usage"
  default     = false
}

variable "glue_connection_name" {
  description = "The name of the connection."
  default     = ""
}

variable "glue_connection_connection_properties" {
  description = "(Required) A map of key-value pairs used as parameters for this connection."
  default     = {}
}

variable "glue_connection_description" {
  description = "(Optional) Description of the connection."
  default     = null
}

variable "glue_connection_catalog_id" {
  description = "(Optional) The ID of the Data Catalog in which to create the connection. If none is supplied, the AWS account ID is used by default."
  default     = null
}

variable "glue_connection_connection_type" {
  description = "(Optional) The type of the connection. Supported are: JDBC, MONGODB. Defaults to JDBC."
  default     = "JDBC"
}

variable "glue_connection_match_criteria" {
  description = "(Optional) A list of criteria that can be used in selecting this connection."
  default     = null
}

variable "glue_connection_physical_connection_requirements" {
  description = "(Optional) A map of physical connection requirements, such as VPC and SecurityGroup. "
  default     = []
}

#glue_job variables
variable "enable_glue_job" {
  description = "Enable glue job usage"
  default     = false
}

variable "glue_job_name" {
  description = "The name you assign to this job. It must be unique in your account."
  default     = ""
}

variable "glue_job_role_arn" {
  description = "The ARN of the IAM role associated with this job."
  default     = null
}

variable "glue_job_command" {
  description = "(Required) The command of the job."
  default     = []
}

variable "glue_job_description" {
  description = "(Optional) Description of the job."
  default     = null
}

variable "glue_job_connections" {
  description = "(Optional) The list of connections used for this job."
  default     = []
}

variable "glue_job_additional_connections" {
  description = "(Optional) The list of connections used for the job."
  default     = []
}

variable "glue_job_default_arguments" {
  description = "(Optional) The map of default arguments for this job. You can specify arguments here that your own job-execution script consumes, as well as arguments that AWS Glue itself consumes. For information about how to specify and consume your own Job arguments, see the Calling AWS Glue APIs in Python topic in the developer guide. For information about the key-value pairs that AWS Glue consumes to set up your job, see the Special Parameters Used by AWS Glue topic in the developer guide."
  default = {
    "--job-language" = "python"
  }
}

variable "glue_job_execution_property" {
  description = "(Optional) Execution property of the job."
  default     = []
}

variable "glue_job_glue_version" {
  description = "(Optional) The version of glue to use, for example '1.0'. For information about available versions, see the AWS Glue Release Notes."
  default     = null
}

variable "glue_job_execution_class" {
  description = "(Optional) Indicates whether the job is run with a standard or flexible execution class. The standard execution class is ideal for time-sensitive workloads that require fast job startup and dedicated resources. Valid value: FLEX, STANDARD."
  default     = null
}

variable "glue_job_max_capacity" {
  description = "(Optional) The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs. Required when pythonshell is set, accept either 0.0625 or 1.0."
  default     = null
}

variable "glue_job_max_retries" {
  description = "(Optional) The maximum number of times to retry this job if it fails."
  default     = null
}

variable "glue_job_notification_property" {
  description = "(Optional) Notification property of the job."
  default     = []
}

variable "glue_job_timeout" {
  description = "(Optional) The job timeout in minutes. The default is 2880 minutes (48 hours)."
  default     = 2880
}

variable "glue_job_security_configuration" {
  description = "(Optional) The name of the Security Configuration to be associated with the job."
  default     = null
}

variable "glue_job_worker_type" {
  description = "(Optional) The type of predefined worker that is allocated when a job runs. Accepts a value of Standard, G.1X, or G.2X."
  default     = null
}

variable "glue_job_number_of_workers" {
  description = "(Optional) The number of workers of a defined workerType that are allocated when a job runs."
  default     = null
}

#glue_workflow variables
variable "enable_glue_workflow" {
  description = "Enable glue workflow usage"
  default     = false
}

variable "glue_workflow_name" {
  description = "The name you assign to this workflow."
  default     = ""
}

variable "glue_workflow_description" {
  description = "(Optional) Description of the workflow."
  default     = null
}

variable "glue_workflow_default_run_properties" {
  description = "(Optional) A map of default run properties for this workflow. These properties are passed to all jobs associated to the workflow."
  default     = null
}

#glue_trigger variables

variable "enable_glue_trigger" {
  description = "Enable glue trigger usage"
  default     = false
}

variable "glue_trigger_name" {
  description = "The name of the trigger."
  default     = ""
}

variable "glue_trigger_type" {
  description = "(Required) The type of trigger. Valid values are CONDITIONAL, ON_DEMAND, and SCHEDULED."
  default     = "ON_DEMAND"
}

variable "glue_trigger_description" {
  description = "(Optional) A description of the new trigger."
  default     = null
}

variable "glue_trigger_enabled" {
  description = "(Optional) Start the trigger. Defaults to true. Not valid to disable for ON_DEMAND type."
  default     = null
}

variable "glue_trigger_schedule" {
  description = "(Optional) A cron expression used to specify the schedule. Time-Based Schedules for Jobs and Crawlers"
  default     = null
}

variable "glue_trigger_workflow_name" {
  description = "(Optional) A workflow to which the trigger should be associated to. Every workflow graph (DAG) needs a starting trigger (ON_DEMAND or SCHEDULED type) and can contain multiple additional CONDITIONAL triggers."
  default     = null
}

variable "glue_trigger_actions" {
  description = "(Required) List of actions initiated by this trigger when it fires. "
  default     = []
}

variable "glue_trigger_timeouts" {
  description = "Set timeouts for glue trigger"
  default     = {}
}

variable "glue_trigger_predicate" {
  description = "(Optional) A predicate to specify when the new trigger should fire. Required when trigger type is CONDITIONAL"
  default     = {}
}