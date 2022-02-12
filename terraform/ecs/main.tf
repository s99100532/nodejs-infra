module "ecs_cluster" {
  source  = "infrablocks/ecs-cluster/aws"
  version = "4.0.0"

  region     = "ap-southeast-1"
  vpc_id     = var.vpc_id
  subnet_ids = [var.ec2_subnet_id]

  component             = "app"
  deployment_identifier = "production"

  cluster_name                         = var.cluster_name
  cluster_instance_ssh_public_key_path = "./public.pub"
  cluster_instance_type                = "t2.micro"
  allowed_cidrs                        = ["0.0.0.0/0"]

  cluster_minimum_size     = 1
  cluster_maximum_size     = 2
  cluster_desired_capacity = 1

  include_asg_capacity_provider = "no"

}



module "ecs_service" {
  source  = "infrablocks/ecs-service/aws"
  version = "4.1.0"

  vpc_id = var.vpc_id

  region = "ap-southeast-1"

  component             = "app"
  deployment_identifier = "production"

  service_name     = var.cluster_name
  service_image    = "327689575644.dkr.ecr.ap-southeast-1.amazonaws.com/nodejs-infra:latest"
  service_port     = "3000"
  target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:327689575644:targetgroup/nodejs-infra/cbb39b52fa6e55f9"

  service_desired_count                      = "1"
  service_deployment_maximum_percent         = "200"
  service_deployment_minimum_healthy_percent = "50"


  service_task_container_definitions = data.aws_s3_bucket_object.task_definition.body

  ecs_cluster_id               = module.ecs_cluster.cluster_id
  ecs_cluster_service_role_arn = module.ecs_cluster.service_role_arn
}

data "aws_s3_bucket_object" "task_definition" {
  bucket = "infra-assets"
  key    = "task_definition.json"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = var.cluster_name

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.subnet_ids
  security_groups = [module.ecs_cluster.security_group_id]
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${var.cluster_name}/${var.cluster_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  name        = "application-scaling-policy-cpu"
  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 20
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}


# resource "aws_lb_target_group" "ecs_elb_target_group" {
#   name     = var.cluster_name
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
# }
