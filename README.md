# Introduction 
This repo includes the Terraform templates for Azure resource deployment. They can be easily deployed via CI/CD pipelines in Azure DevOps. 

The deployment includes the creation of:
- Resource Group (where all the following resources will be stored in)
- Virtual Network (including subnets)
- Application Insights 
- Key Vault 
- Storage Account 
- Machine Learning Workspace 

# Getting Started and Test it Yourself
You will need an Azure subscription and access to Azure DevOps to complete this deployment. 

1. Clone this repo and import it to your Azure Repo in your own DevOps project.

Build pipeline (for validating the code):
1. Navigate to 'pipelines' under 'Pipelines' section and select 'New Pipeline'
2. Click on 'use the classic editor' at the bottom 
3. Select ‘Azure Repo Git’ （if you have moved the repo into Azure repo) and specify the repo and branch names then 'continue'
4. Select 'Start with an empty job' then add the following tasks
    - 'Terraform tool installer': where you specify the terraform version e.g. 0.14.6
    - 'Terraform': select the 'init' command and specify the storage location for the terraform state file
    - 'Terraform': select the 'validate' command
    - 'Copy Files': copy the terraform template files to the deployment folder (for release pipelines later on)
    - 'Publish build artifacts': publish the build artifacts to the deployment folder 

Release pipeline (for deploying to the cloud):
1. Navigate to 'releases' under 'Pipelines' section and select 'New release pipeline'
2. 'Start with an empty job' and 'add an artifact' by selecting the 'build' source type and specifying the project and source 
3. Under stages, add the following tasks:
    - 'Terraform tool installer': where you specify the terraform version e.g. 0.14.6
    - 'Terraform': select the 'init' command and specify the storage location for the terraform state file
    - 'Terraform': select the 'plan' command where it will download all the dependencies 
    - 'Terraform': select the 'validate and plan' command where it will validate the code again and apply the deployment
4. Congratulations the deployment is done! :) 



I have recorded a step by step tutorial to guide you through (link will be uploaded soon).

# Further Learning Resources 
Check out the learning resources below if you want to learn more about Infrastructure as Code on Azure 

- [What is Infrastructure as Code](https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code?WT.mc_id=azuredevops-azuredevops-jagord)
- [Terraform on Azure Documentation](https://docs.microsoft.com/en-au/azure/developer/terraform/overview)
- [Terraform Testing Overview](https://docs.microsoft.com/en-au/azure/developer/terraform/best-practices-testing-overview)
- [Tutorial on Automate Cloud Resource Management](https://docs.microsoft.com/en-us/learn/modules/cmu-orchestration/)
- [Tutorial on IaC using Bicep](https://docs.microsoft.com/en-us/learn/modules/introduction-to-infrastructure-as-code-using-bicep/)
