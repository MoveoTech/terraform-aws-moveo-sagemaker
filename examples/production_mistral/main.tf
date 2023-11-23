# ---------------------------------------------------------------------------------------------------------------------
# Example Asynchronous Endpoint
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region  = "us-east-1"
  profile = "tangi-prod"
}

module "huggingface_sagemaker" {
  source               = "../../"
  name_prefix          = "llm-v2-production"
  tgi_version          = "1.1.0"
  instance_type        = "ml.g5.2xlarge"
  hf_model_id          = "tangibly-org/tangibly-patents-v2"
  hf_task              = "text-generation"
  hf_api_token         = "hf_token"
  num_gpus             = 1
  max_input_length     = 2048
  max_total_tokens     = 4096
  quantization         = "bitsandbytes-nf4"
  security_group_ids   = ["sg-0a97fcb3a1c583988"]
  subnets              = ["subnet-03568d0cc4f7b60ab"]
}
