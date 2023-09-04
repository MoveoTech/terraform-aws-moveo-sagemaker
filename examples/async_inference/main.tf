# ---------------------------------------------------------------------------------------------------------------------
# Example Asynchronous Endpoint
# ---------------------------------------------------------------------------------------------------------------------

locals {
  bucket_name = "sagemaker-model-inference"
}

provider "aws" {
  region  = "us-east-1"
  # profile = "hf-sm"
}

# create bucket for async inference for inputs & outputs
resource "aws_s3_bucket" "async_inference_bucket" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = local.bucket_name
  rule {
    id = "auto-delete-objects"
    expiration {
      days = 1
    }
    status = "Enabled"
  }
}

module "huggingface_sagemaker" {
  source               = "../../"
  name_prefix          = "tangibly-llm-v1"
  tgi_version          = "0.9.3"
  instance_type        = "ml.g5.12xlarge"
  hf_model_id          = "tiiuae/falcon-40b"
  hf_task              = "text-generation"
  transformers_version = "4.23.0"
  hf_api_token         = "hf_xxxxx"
  async_config = {
    # needs to be a s3 uri
    s3_output_path = "s3://${local.bucket_name}/outputs"
    # (Optional) specify Amazon SNS topics and custom KMS Key
    # kms_key_id        = "string"
    # sns_error_topic   = "arn:aws:sns:aws-region:account-id:topic-name"
    # sns_success_topic = "arn:aws:sns:aws-region:account-id:topic-name"
  }
  autoscaling = {
    min_capacity      = 0
    max_capacity      = 1
    target_value      = 0.5
    # for using customized metric https://docs.aws.amazon.com/sagemaker/latest/dg/async-inference-monitor.html#async-inference-monitor-cloudwatch-async
    customized_metric = {
      metric_name = "HasBacklogWithoutCapacity"
      statistic   = "Maximum"
    }
  }
}
