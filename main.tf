terraform {
  required_version = ">= 1.3"
  backend "s3"{}
}

terraform {
  required_providers {
    aws = ">= 4.52.0"
  }
}
provider "aws" {
  region = "us-east-1"
}

#---------------------------------------------------
# AWS Glue catalog database
#---------------------------------------------------
resource "aws_glue_catalog_database" "glue_catalog_database" {
  count = var.enable_glue_catalog_database ? 1 : 0

  name = var.glue_catalog_database_name != "" ? lower(var.glue_catalog_database_name) : "${lower(var.name)}-glue-catalog-db-${lower(var.environment)}"

  description  = var.glue_catalog_database_description
  catalog_id   = var.glue_catalog_database_catalog_id
  location_uri = var.glue_catalog_database_location_uri
  parameters   = var.glue_catalog_database_parameters

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}

#---------------------------------------------------
# AWS glue security configuration
#---------------------------------------------------
resource "aws_glue_security_configuration" "glue_security_configuration" {
  count = var.enable_glue_security_configuration ? 1 : 0

  name = var.glue_security_configuration_name != "" ? lower(var.glue_security_configuration_name) : "${lower(var.name)}-glue-sec-conf-${lower(var.environment)}"

  encryption_configuration {
    dynamic "cloudwatch_encryption" {
      iterator = cloudwatch_encryption
      for_each = lookup(var.glue_security_configuration_encryption_configuration, "cloudwatch_encryption", [])

      content {
        cloudwatch_encryption_mode = lookup(cloudwatch_encryption.value, "cloudwatch_encryption_mode", null)
        kms_key_arn                = lookup(cloudwatch_encryption.value, "kms_key_arn", null)
      }
    }

    dynamic "job_bookmarks_encryption" {
      iterator = job_bookmarks_encryption
      for_each = lookup(var.glue_security_configuration_encryption_configuration, "job_bookmarks_encryption", [])

      content {
        job_bookmarks_encryption_mode = lookup(job_bookmarks_encryption.value, "job_bookmarks_encryption_mode", null)
        kms_key_arn                   = lookup(job_bookmarks_encryption.value, "kms_key_arn", null)
      }
    }

    dynamic "s3_encryption" {
      iterator = s3_encryption
      for_each = lookup(var.glue_security_configuration_encryption_configuration, "s3_encryption", [])

      content {
        s3_encryption_mode = lookup(s3_encryption.value, "s3_encryption_mode", null)
        kms_key_arn        = lookup(s3_encryption.value, "kms_key_arn", null)
      }
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}
#---------------------------------------------------
# AWS Glue catalog table
#---------------------------------------------------
resource "aws_glue_catalog_table" "glue_catalog_table" {
  count = var.enable_glue_catalog_table ? 1 : 0

  name          = var.glue_catalog_table_name != "" ? lower(var.glue_catalog_table_name) : "${lower(var.name)}-glue-catalog-table-${lower(var.environment)}"
  database_name = var.glue_catalog_table_database_name != "" && !var.enable_glue_catalog_database ? var.glue_catalog_table_database_name : element(concat(aws_glue_catalog_database.glue_catalog_database.*.name, [""]), 0)

  description        = var.glue_catalog_table_description
  catalog_id         = var.glue_catalog_table_catalog_id
  owner              = var.glue_catalog_table_owner
  retention          = var.glue_catalog_table_retention
  view_original_text = var.glue_catalog_table_view_original_text
  view_expanded_text = var.glue_catalog_table_view_expanded_text
  table_type         = var.glue_catalog_table_table_type != null ? upper(var.glue_catalog_table_table_type) : var.glue_catalog_table_table_type
  parameters         = var.glue_catalog_table_parameters

  dynamic "partition_keys" {
    iterator = partition_keys
    for_each = var.glue_catalog_table_partition_keys

    content {
      name    = lookup(partition_keys.value, "name", null)
      type    = lookup(partition_keys.value, "type", null)
      comment = lookup(partition_keys.value, "comment", null)
    }
  }

  storage_descriptor {
    location                  = lookup(var.glue_catalog_table_storage_descriptor, "location", null)
    input_format              = lookup(var.glue_catalog_table_storage_descriptor, "input_format", null)
    output_format             = lookup(var.glue_catalog_table_storage_descriptor, "output_format", null)
    compressed                = lookup(var.glue_catalog_table_storage_descriptor, "compressed", null)
    number_of_buckets         = lookup(var.glue_catalog_table_storage_descriptor, "number_of_buckets", null)
    bucket_columns            = lookup(var.glue_catalog_table_storage_descriptor, "bucket_columns", null)
    parameters                = lookup(var.glue_catalog_table_storage_descriptor, "parameters", null)
    stored_as_sub_directories = lookup(var.glue_catalog_table_storage_descriptor, "stored_as_sub_directories", null)

    dynamic "columns" {
      iterator = columns
      for_each = lookup(var.glue_catalog_table_storage_descriptor, "columns", [])

      content {
        name    = lookup(columns.value, "columns_name", null)
        type    = lookup(columns.value, "columns_type", null)
        comment = lookup(columns.value, "columns_comment", null)
      }
    }

    dynamic "ser_de_info" {
      iterator = ser_de_info
      for_each = lookup(var.glue_catalog_table_storage_descriptor, "ser_de_info", [])

      content {
        name                  = lookup(ser_de_info.value, "ser_de_info_name", null)
        parameters            = lookup(ser_de_info.value, "ser_de_info_parameters", null)
        serialization_library = lookup(ser_de_info.value, "ser_de_info_serialization_library", null)
      }
    }

    dynamic "sort_columns" {
      iterator = sort_columns
      for_each = lookup(var.glue_catalog_table_storage_descriptor, "sort_columns", [])

      content {
        column     = lookup(sort_columns.value, "sort_columns_column", null)
        sort_order = lookup(sort_columns.value, "sort_columns_sort_order", null)
      }
    }

    dynamic "skewed_info" {
      iterator = skewed_info
      for_each = lookup(var.glue_catalog_table_storage_descriptor, "skewed_info", [])

      content {
        skewed_column_names               = lookup(skewed_info.value, "skewed_info_skewed_column_names", null)
        skewed_column_value_location_maps = lookup(skewed_info.value, "skewed_info_skewed_column_value_location_maps", null)
        skewed_column_values              = lookup(skewed_info.value, "skewed_info_skewed_column_values", null)
      }
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_glue_catalog_database.glue_catalog_database
  ]
}

#---------------------------------------------------
# AWS Glue crawler
#---------------------------------------------------
resource "aws_glue_crawler" "glue_crawler" {
  count = var.enable_glue_crawler ? 1 : 0

  name          = var.glue_crawler_name != "" ? lower(var.glue_crawler_name) : "${lower(var.name)}-glue-crawler-${lower(var.environment)}"
  database_name = var.glue_database_name != "" && !var.enable_glue_catalog_database ? var.glue_database_name : element(concat(aws_glue_catalog_database.glue_catalog_database.*.name, [""]), 0)
  role          = var.glue_role

  description            = var.glue_crawler_description
  classifiers            = var.glue_classifiers
  configuration          = var.glue_configuration
  schedule               = var.glue_schedule
  security_configuration = var.glue_security_configuration != "" && !var.enable_glue_security_configuration ? var.glue_security_configuration : element(concat(aws_glue_security_configuration.glue_security_configuration.*.id, [""]), 0)
  table_prefix           = var.glue_table_prefix

  dynamic "dynamodb_target" {
    iterator = dynamodb_target
    for_each = var.glue_dynamodb_target

    content {
      path = lookup(dynamodb_target.value, "path", null)
    }
  }

  dynamic "jdbc_target" {
    iterator = jdbc_target
    for_each = var.glue_jdbc_target

    content {
      connection_name = lookup(jdbc_target.value, "connection_name", null)
      path            = lookup(jdbc_target.value, "path", null)
      exclusions      = lookup(jdbc_target.value, "exclusions", null)
    }
  }

  dynamic "s3_target" {
    iterator = s3_target
    for_each = var.glue_s3_target

    content {
      path       = lookup(s3_target.value, "path", null)
      exclusions = lookup(s3_target.value, "exclusions", null)
    }
  }

  dynamic "catalog_target" {
    iterator = catalog_target
    for_each = length(var.glue_catalog_target) > 0 ? [var.glue_catalog_target] : []

    content {
      database_name = lookup(catalog_target.value, "database_name", (var.enable_glue_catalog_database ? element(concat(aws_glue_catalog_database.glue_catalog_database.*.id, [""]), 0) : null))
      tables        = lookup(catalog_target.value, "tables", (var.enable_glue_catalog_table ? element(concat(aws_glue_catalog_table.glue_catalog_table.*.id, [""]), 0) : null))
    }
  }

  dynamic "schema_change_policy" {
    iterator = schema_change_policy
    for_each = var.glue_schema_change_policy

    content {
      delete_behavior = lookup(schema_change_policy.value, "delete_behavior", null)
      update_behavior = lookup(schema_change_policy.value, "update_behavior", null)
    }
  }

  dynamic "mongodb_target" {
    iterator = mongodb_target
    for_each = var.glue_mongodb_target

    content {
      connection_name = lookup(mongodb_target.value, "connection_name", null)

      path     = lookup(mongodb_target.value, "path", null)
      scan_all = lookup(mongodb_target.value, "scan_all", null)
    }
  }

  dynamic "lineage_configuration" {
    iterator = lineage_configuration
    for_each = var.glue_lineage_configuration

    content {
      crawler_lineage_settings = lookup(lineage_configuration.value, "crawler_lineage_settings", null)
    }
  }

  dynamic "recrawl_policy" {
    iterator = recrawl_policy
    for_each = var.glue_recrawl_policy

    content {
      recrawl_behavior = lookup(recrawl_policy.value, "recrawl_behavior", null)
    }
  }

  tags = merge(
    {
      Name = var.glue_crawler_name != "" ? lower(var.glue_crawler_name) : "${lower(var.name)}-glue-crawler-${lower(var.environment)}"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_glue_catalog_database.glue_catalog_database,
    aws_glue_security_configuration.glue_security_configuration,
    aws_glue_catalog_table.glue_catalog_table
  ]
}

#---------------------------------------------------
# AWS Glue connection
#---------------------------------------------------
resource "aws_glue_connection" "glue_connection" {
  count = var.enable_glue_connection ? 1 : 0

  name                  = var.glue_connection_name != "" ? lower(var.glue_connection_name) : "${lower(var.name)}-glue-connection-${lower(var.environment)}"
  connection_properties = var.glue_connection_connection_properties

  description     = var.glue_connection_description
  catalog_id      = var.glue_connection_catalog_id
  connection_type = upper(var.glue_connection_connection_type)
  match_criteria  = var.glue_connection_match_criteria

  dynamic "physical_connection_requirements" {
    iterator = physical_connection_requirements
    for_each = var.glue_connection_physical_connection_requirements

    content {
      availability_zone      = lookup(physical_connection_requirements.value, "availability_zone", null)
      security_group_id_list = lookup(physical_connection_requirements.value, "security_group_id_list", [])
      subnet_id              = lookup(physical_connection_requirements.value, "subnet_id", null)
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}

#---------------------------------------------------
# AWS Glue job
#---------------------------------------------------
resource "aws_glue_job" "glue_job" {
  count = var.enable_glue_job ? 1 : 0

  name     = var.glue_job_name != "" ? lower(var.glue_job_name) : "${lower(var.name)}-glue-job-${lower(var.environment)}"
  role_arn = var.glue_job_role_arn

  description            = var.glue_job_description
  connections            = length(var.glue_job_connections) > 0 ? var.glue_job_connections : (var.enable_glue_connection ? concat(var.glue_job_additional_connections, [element(concat(aws_glue_connection.glue_connection.*.id, [""]), 0)]) : [])
  default_arguments      = var.glue_job_default_arguments
  glue_version           = var.glue_job_glue_version
  execution_class        = var.glue_job_execution_class
  #max_capacity           = var.glue_job_max_capacity
  max_retries            = var.glue_job_max_retries
  timeout                = var.glue_job_timeout
  security_configuration = var.glue_job_security_configuration != "" && !var.enable_glue_security_configuration ? var.glue_job_security_configuration : element(concat(aws_glue_security_configuration.glue_security_configuration.*.id, [""]), 0)
  worker_type            = var.glue_job_worker_type
  number_of_workers      = var.glue_job_number_of_workers

  dynamic "command" {
    iterator = command
    for_each = var.glue_job_command

    content {
      script_location = lookup(command.value, "script_location", null)

      name           = lookup(command.value, "name", null)
      python_version = lookup(command.value, "python_version", null)
    }
  }

  dynamic "execution_property" {
    iterator = execution_property
    for_each = var.glue_job_execution_property

    content {
      max_concurrent_runs = lookup(execution_property.value, "max_concurrent_runs", 1)
    }
  }

  dynamic "notification_property" {
    iterator = notification_property
    for_each = var.glue_job_notification_property

    content {
      notify_delay_after = lookup(notification_property.value, "notify_delay_after", null)
    }
  }

  tags = merge(
    {
      Name = var.glue_job_name != "" ? lower(var.glue_job_name) : "${lower(var.name)}-glue-job-${lower(var.environment)}"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_glue_connection.glue_connection,
    aws_glue_security_configuration.glue_security_configuration
  ]
}

#---------------------------------------------------
# AWS Glue workflow
#---------------------------------------------------
resource "aws_glue_workflow" "glue_workflow" {
  count = var.enable_glue_workflow ? 1 : 0

  name = var.glue_workflow_name != "" ? lower(var.glue_workflow_name) : "${lower(var.name)}-glue-workflow-${lower(var.environment)}"

  description            = var.glue_workflow_description
  default_run_properties = var.glue_workflow_default_run_properties

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}

#---------------------------------------------------
# AWS Glue trigger
#---------------------------------------------------
resource "aws_glue_trigger" "glue_trigger" {
  count = var.enable_glue_trigger ? 1 : 0

  name = var.glue_trigger_name != "" ? lower(var.glue_trigger_name) : "${lower(var.name)}-glue-trigger-${lower(var.environment)}"
  type = upper(var.glue_trigger_type)

  description   = var.glue_trigger_description
  enabled       = var.glue_trigger_enabled
  schedule      = var.glue_trigger_schedule
  workflow_name = var.glue_trigger_workflow_name != "" && !var.enable_glue_workflow ? var.glue_trigger_workflow_name : element(concat(aws_glue_workflow.glue_workflow.*.id, [""]), 0)

  dynamic "actions" {
    iterator = actions
    for_each = var.glue_trigger_actions

    content {
      arguments = lookup(actions.value, "arguments", null)
      # Both JobName or CrawlerName cannot be set together in an action
      crawler_name = lookup(actions.value, "crawler_name", (var.enable_glue_crawler && !var.enable_glue_job ? element(concat(aws_glue_crawler.glue_crawler.*.id, [""]), 0) : null))
      job_name     = lookup(actions.value, "job_name", (var.enable_glue_job && !var.enable_glue_crawler ? element(concat(aws_glue_job.glue_job.*.id, [""]), 0) : null))
      timeout      = lookup(actions.value, "timeout", null)
    }
  }

  dynamic "predicate" {
    iterator = predicate
    for_each = length(keys(var.glue_trigger_predicate)) > 0 ? [var.glue_trigger_predicate] : []

    content {
      logical = lookup(predicate.value, "logical", null)

      dynamic "conditions" {
        iterator = conditions
        for_each = lookup(predicate.value, "conditions", [])

        content {
          job_name         = lookup(conditions.value, "job_name", null)
          state            = lookup(conditions.value, "state", null)
          crawler_name     = lookup(conditions.value, "crawler_name", null)
          crawl_state      = lookup(conditions.value, "crawl_state", null)
          logical_operator = lookup(conditions.value, "logical_operator", null)
        }
      }
    }
  }

  dynamic "timeouts" {
    iterator = timeouts
    for_each = length(keys(var.glue_trigger_timeouts)) > 0 ? [var.glue_trigger_timeouts] : []

    content {
      create = lookup(timeouts.value, "create", null)
      delete = lookup(timeouts.value, "delete", null)
    }
  }

  tags = merge(
    {
      Name = var.glue_trigger_name != "" ? lower(var.glue_trigger_name) : "${lower(var.name)}-glue-trigger-${lower(var.environment)}"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_glue_workflow.glue_workflow,
    aws_glue_crawler.glue_crawler,
    aws_glue_job.glue_job
  ]
}