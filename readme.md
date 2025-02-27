# AWS Auto Scaling Project

This project demonstrates how to create a highly available and scalable web application infrastructure on AWS using CloudFormation. The architecture includes Auto Scaling Groups, Application Load Balancer, and dynamic scaling policies.

## Architecture

![AWS Architecture](https://via.placeholder.com/800x400?text=AWS+Auto+Scaling+Architecture)

The infrastructure includes:

- **VPC with 3 Availability Zones** - Each containing public and private subnets
- **Application Load Balancer** - Distributes incoming traffic across multiple EC2 instances
- **Auto Scaling Group** - Automatically adjusts the number of EC2 instances based on demand
- **Custom EC2 Instances** - Web servers with a simple demo application
- **Dynamic Scaling Policies** - Based on CPU utilization and request count

## CloudFormation Stacks

The infrastructure is deployed using three CloudFormation stacks:

1. **VPC Stack** - Creates the network infrastructure (VPC, subnets, route tables, etc.)
2. **Launch Template Stack** - Defines the EC2 instance configuration with UserData script
3. **Auto Scaling Stack** - Creates the Auto Scaling Group, ALB, and scaling policies

## Deployment Instructions

### Prerequisites

- AWS CLI installed and configured
- Basic knowledge of AWS services
- An AWS account with appropriate permissions

### Deployment Steps

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/aws-autoscaling-project.git
   cd aws-autoscaling-project
   ```

2. Deploy the VPC stack:
   ```bash
   aws cloudformation create-stack \
     --stack-name vpc-stack \
     --template-body file://vpc-template.yaml \
     --capabilities CAPABILITY_IAM
   ```

3. Wait for the VPC stack to complete:
   ```bash
   aws cloudformation wait stack-create-complete --stack-name vpc-stack
   ```

4. Deploy the Launch Template stack:
   ```bash
   aws cloudformation create-stack \
     --stack-name launch-template-stack \
     --template-body file://launch-template.yaml \
     --parameters ParameterKey=VpcStackName,ParameterValue=vpc-stack \
     --capabilities CAPABILITY_IAM
   ```

5. Wait for the Launch Template stack to complete:
   ```bash
   aws cloudformation wait stack-create-complete --stack-name launch-template-stack
   ```

6. Deploy the Auto Scaling Group stack:
   ```bash
   aws cloudformation create-stack \
     --stack-name asg-stack \
     --template-body file://asg-alb-template.yaml \
     --parameters ParameterKey=VpcStackName,ParameterValue=vpc-stack \
                  ParameterKey=LaunchTemplateStackName,ParameterValue=launch-template-stack
   ```

7. Get the DNS name of your load balancer:
   ```bash
   aws cloudformation describe-stacks \
     --stack-name asg-stack \
     --query "Stacks[0].Outputs[?OutputKey=='LoadBalancerDNSName'].OutputValue" \
     --output text
   ```

8. Open the DNS name in your browser to access the demo application.

## Testing Auto Scaling

1. To test the Auto Scaling capabilities, access the load testing page:
   ```
   http://<your-load-balancer-dns>/load.html
   ```

2. This page will generate CPU load on the server, which should trigger a scale-out event if enough instances are accessed simultaneously.

3. Monitor the Auto Scaling group in the AWS Console to see instances being added or removed.

## Cleanup

To avoid incurring charges, delete the stacks when you're done:

```bash
aws cloudformation delete-stack --stack-name asg-stack
aws cloudformation wait stack-delete-complete --stack-name asg-stack

aws cloudformation delete-stack --stack-name launch-template-stack
aws cloudformation wait stack-delete-complete --stack-name launch-template-stack

aws cloudformation delete-stack --stack-name vpc-stack
```

## Skills Demonstrated

This project demonstrates the following AWS skills:

- AWS CloudFormation for Infrastructure as Code
- VPC network design with public and private subnets
- Auto Scaling Group configuration
- Application Load Balancer setup
- EC2 UserData scripting
- Dynamic scaling policies based on metrics
- High-availability architecture across multiple Availability Zones

---

Feel free to customize and expand upon this project for your own learning and portfolio needs!
