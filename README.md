BEGINNER PROJECT 2. NETWORK ARCHITECTURE WITH TERRAFORM FOR A SMALL BUT BOOMING BUSINESS
This network architecture design is an add-on to my initial cloud architecture project in the repository izziedelph/CCFS for a small but booming business that is migrating to the cloud. I have implemented a network architecture for the initial design and expanded upon it. 
For this phase of the Crawley Caribbean Food Service (CCFS-2) project, the focus has been on building a Multi-Tier Network Architecture using Terraform, and implement a GitHub Actions workflow that stops at the terraform plan stage, leaving terraform apply for manual execution. I had issue with Github actions with the first phase which I eventually had to delete so I decided to include it for this one, at least partially up to terraform plan. 
This multi-Tier Network Architecture is ideal for structuring our cloud environment for security, scalability, and high availability. The key components include:
VPC (Virtual Private Cloud) to isolate your network.

Subnets:
Public Subnet: for resources like load balancers (ALB) and NAT gateways that need internet access.

Private Subnets: for application servers (EC2) and databases (RDS) that should not be exposed to the internet directly.

Internet Gateway (IGW) for internet access.

NAT Gateway for secure outbound traffic from private subnets.
Route Tables for routing traffic.

Security Groups and Network ACLs to define network-level security.

I have also included a GitHub Actions workflow for automated checks (CI/CD) that stops at terraform plan.

Route tables have also been included and this design flow has been verified in the AWS console with no issues. 

Breakdown of Components:
VPC - A dedicated virtual network for CCFS.
Public Subnet - For resources that need internet access like the ALB and NAT Gateway.
Private Subnet: - For instances that shouldn't be exposed directly to the internet (like the EC2 instances and RDS).
Internet Gateway - Enables internet access for the VPC.
NAT Gateway - Allows instances in the private subnet to access the internet for updates, etc.
Security Groups - Controls inbound/outbound traffic for EC2 and ALB.

See phase one (repository izziedelph/CCFS) for references to some of these resources like ALB, RDS, ECS etc
