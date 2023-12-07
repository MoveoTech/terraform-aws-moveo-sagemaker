# ---------------------------------------------------------------------------------------------------------------------
# Example Asynchronous Endpoint
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
  # profile = "hf-sm"
}

module "huggingface_sagemaker" {
  source           = "../../"
  name_prefix      = "llm-v220-development"
  tgi_version      = "1.1.0"
  instance_type    = "ml.g5.2xlarge"
  hf_model_id      = "tangibly-org/tangibly-patents-v2-merged"
  hf_task          = "text-generation"
  hf_api_token     = "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"
  num_gpus         = 1
  max_input_length = 2048
  max_total_tokens = 4096
  quantization     = "bitsandbytes-nf4"
}
