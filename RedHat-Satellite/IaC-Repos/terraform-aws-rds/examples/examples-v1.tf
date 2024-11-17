terraform {
  required_version = "~> 1.0" # Specify the required Terraform version
}

# Configure the AWS provider
provider "aws" {
  region                   = "us-east-1"                        # Set the AWS region
  shared_credentials_files = [pathexpand("~/.aws/credentials")] # Path to AWS credentials file
}

# Module for creating an Aurora MySQL cluster
module "rds_cluster" {
  source = "../../modules/rds" # Path to the RDS module

  name        = "Test"      # Name for the RDS resources
  region      = "us-east-1" # AWS region
  environment = "stage"     # Environment (e.g., dev, stage, prod)

  # Disable RDS cluster parameter group creation
  enable_rds_cluster_parameter_group = false
  # Name of the RDS cluster parameter group (if enabled)
  rds_cluster_parameter_group_name = "rds-cluster-parameter-group-name"
  # Parameters for the RDS cluster parameter group
  rds_cluster_parameter_group_parameters = [
    {
      name  = "character_set_server" # Parameter name
      value = "utf8"                 # Parameter value
    },
    {
      name  = "character_set_client"
      value = "utf8"
    }
  ]

  # Enable DB subnet group creation
  enable_db_subnet_group = true
  # Name of the DB subnet group
  db_subnet_group_name = "db_parameter_group_name"
  # Subnet IDs for the DB subnet group
  db_subnet_group_subnet_ids = ["subnet-01e1e21d1f1c0b1fa", "subnet-09d00c1d07ea7b939", "subnet-0503fc0754cf9460e"]

  # RDS Cluster Configuration
  enable_rds_cluster             = true        # Enable RDS cluster creation
  rds_cluster_cluster_identifier = "rds-mysql" # Identifier for the RDS cluster
  rds_cluster_engine             = "aurora"    # Database engine (Aurora MySQL)
  rds_cluster_engine_version     = null        #"5.7.12" # Engine version (optional)

  rds_cluster_engine_mode = "provisioned" # Engine mode (provisioned or serverless)

  # RDS Cluster Instance Configuration
  enable_rds_cluster_instance         = true          # Enable RDS cluster instance creation
  number_rds_cluster_instances        = 1             # Number of cluster instances
  rds_cluster_instance_engine         = "aurora"      # Database engine for the instance
  rds_cluster_instance_engine_version = null          #"5.7.12" # Engine version for the instance (optional)
  rds_cluster_instance_instance_class = "db.t2.small" # Instance class

  # Tags for the RDS resources
  tags = tomap({
    "Environment"   = "dev"
    "Createdby"     = "Amit Patel"
    "Orchestration" = "Terraform"
  })
}

# Module for creating an Oracle RDS instance
module "db_instance-rds-oracle" {
  source      = "../../modules/rds" # Path to the RDS module
  name        = "rds-oracle"        # Name for the RDS resources
  environment = "stage"             # Environment
  region      = "us-east-1"         # AWS region

  # Enable subnet usage
  enable_db_subnet_group     = true
  db_subnet_group_name       = "test-db-instance-rds-oracle-db-subnet-group" # Name of the DB subnet group
  db_subnet_group_subnet_ids = ["sub-fs432fd", "sub-432dfcxr"]               # Subnet IDs

  # Disable DB parameter group creation
  enable_db_parameter_group     = false
  db_parameter_group_name       = "test-db-instance-rds-oracle-db-param-group"
  db_parameter_group_parameters = []
  db_parameter_group_family     = ""

  # Disable DB option group creation
  enable_db_option_group               = false
  db_option_group_name                 = "test-db-instance-rds-oracle-db-group-name"
  db_option_group_engine_name          = "oracle-ee"
  db_option_group_major_engine_version = "12.1"
  db_option_group_options              = []

  # Instance Configuration
  db_instance_multi_az          = false # Disable Multi-AZ deployment
  db_instance_availability_zone = null  # Availability zone (optional)

  db_instance_allocated_storage     = 50   # Initial storage size (GB)
  db_instance_max_allocated_storage = null # Maximum storage size (optional)
  db_instance_storage_type          = null #"gp2" # Storage type (optional)
  db_instance_iops                  = null # Provisioned IOPS (optional)

  db_instance_storage_encrypted = false # Disable storage encryption
  db_instance_kms_key_id        = null  # KMS key ID (optional)

  # Enable DB instance creation
  enable_db_instance     = true
  number_of_instances    = 1                             # Number of instances
  db_instance_identifier = "test-db-instance-rds-oracle" # Instance identifier
  db_instance_engine     = "oracle-se2"                  # Database engine (Oracle SE2)
  #db_instance_engine_version                = "12.1" # Engine version (optional)
  db_instance_license_model                = "license-included" # License model
  db_instance_instance_class               = "db.t3.small"      # Instance class
  db_instance_vpc_security_group_ids       = []                 # VPC security group IDs
  db_instance_performance_insights_enabled = true               # Enable Performance Insights
  db_instance_skip_final_snapshot          = true               # Skip final snapshot on deletion

  # Database Settings
  db_instance_db_name     = "testdb"         # Database name
  db_instance_db_username = "root"           # Database username
  db_instance_db_password = "ImPassWorD2020" # Database password

  # Disable DB instance role association
  enable_db_instance_role_association       = false
  db_instance_role_association_feature_name = ""
  db_instance_role_association_role_arn     = ""

  # Tags for the RDS resources
  tags = tomap({
    "Environment"   = "dev"
    "Createdby"     = "Amit Patel"
    "Orchestration" = "Terraform"
  })
}

# Module for creating a simple Postgres 14 instance
module "db_instance-rds-postgres-simple" {
  source      = "../../modules/rds"   # Path to the RDS module
  name        = "rds-postgres-simple" # Name for the RDS resources
  environment = "stage"               # Environment
  region      = "us-east-1"           # AWS region

  # Enable subnet usage
  enable_db_subnet_group     = true
  db_subnet_group_name       = "test-db-instance-rds-postgres-simple-db-subnet-group"                               # Name of the DB subnet group
  db_subnet_group_subnet_ids = ["subnet-01e1e21d1f1c0b1fa", "subnet-09d00c1d07ea7b939", "subnet-0503fc0754cf9460e"] # Subnet IDs

  # Enable DB instance creation
  enable_db_instance         = true
  number_of_instances        = 1                                      # Number of instances
  db_instance_identifier     = "test-db-instance-rds-postgres-simple" # Instance identifier
  db_instance_engine         = "postgres"                             # Database engine (Postgres)
  db_instance_engine_version = "14"                                   # Engine version (Postgres 14)
  db_instance_instance_class = "db.t3.micro"                          # Instance class

  # Database Settings
  db_instance_db_name     = "simple_db"          # Database name
  db_instance_db_username = "simple_user"        # Database username
  db_instance_db_password = "SimplePassword123!" # Database password

  # Tags for the RDS resources
  tags = tomap({
    "Environment"   = "dev"
    "Createdby"     = "Amit Patel"
    "Orchestration" = "Terraform"
  })
}

# Module for creating a complex Postgres 14 instance with parameter group and option group
module "db_instance-rds-postgres-complex" {
  source      = "../../modules/rds"    # Path to the RDS module
  name        = "rds-postgres-complex" # Name for the RDS resources
  environment = "stage"                # Environment
  region      = "us-east-1"            # AWS region

  # Enable subnet usage
  enable_db_subnet_group     = true
  db_subnet_group_name       = "test-db-instance-rds-postgres-complex-db-subnet-group"                              # Name of the DB subnet group
  db_subnet_group_subnet_ids = ["subnet-01e1e21d1f1c0b1fa", "subnet-09d00c1d07ea7b939", "subnet-0503fc0754cf9460e"] # Subnet IDs

  # Enable DB parameter group creation
  enable_db_parameter_group = true
  db_parameter_group_name   = "test-db-instance-rds-postgres-complex-db-param-group" # Name of the DB parameter group
  # Parameters for the DB parameter group
  db_parameter_group_parameters = [
    {
      name         = "shared_buffers" # Parameter name
      value        = "256MB"          # Parameter value
      apply_method = "pending-reboot" # Apply method (pending-reboot or immediate)
    },
    {
      name         = "work_mem"
      value        = "64MB"
      apply_method = "immediate"
    }
  ]
  db_parameter_group_family = "postgres14" # Parameter group family

  # Enable DB option group creation
  enable_db_option_group               = true
  db_option_group_name                 = "test-db-instance-rds-postgres-complex-db-group-name" # Name of the DB option group
  db_option_group_engine_name          = "postgres"                                            # Database engine
  db_option_group_major_engine_version = "14"                                                  # Major engine version
  # Options for the DB option group
  db_option_group_options = [
    {
      option_name = "pgaudit" # Option name
      version     = "1.4"     # Option version
      option_settings = {     # Option settings
        name  = "pgaudit.log" # Setting name
        value = "all"         # Setting value
      }
    }
  ]

  # Enable DB instance creation
  enable_db_instance         = true
  number_of_instances        = 1                                       # Number of instances
  db_instance_identifier     = "test-db-instance-rds-postgres-complex" # Instance identifier
  db_instance_engine         = "postgres"                              # Database engine (Postgres)
  db_instance_engine_version = "14"                                    # Engine version (Postgres 14)
  db_instance_instance_class = "db.t3.medium"                          # Instance class

  # Database Settings
  db_instance_db_name     = "complex_db"          # Database name
  db_instance_db_username = "complex_user"        # Database username
  db_instance_db_password = "ComplexPassword123!" # Database password

  # Tags for the RDS resources
  tags = tomap({
    "Environment"   = "dev"
    "Createdby"     = "Amit Patel"
    "Orchestration" = "Terraform"
  })
}
