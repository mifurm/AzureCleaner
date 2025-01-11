# Azure Cleaner

## Goal of this repo

Simple repo of scripts to find unused or orphaned resources in Azure.
Every service in Azure (like Virtual Machine or Public IP address) has it's own file.
Scripts DO NOT delete any Azure resources, the goal is to list the resources with the high propensity of not being used, properly attached on configured.

You use those scripts on your own risks.

## How to use those scripts?
Look through the scripts in the repo and find the service you are looking for.
Then, open PowerShell console and use the script there by logging into Azure with your account.
You may need specific permissions to read some configuration details per service.

## Future goal
- Add a table in the README.MD file to list all the script with comments what they are doing
- Add a roboust description to explain what permissions you need to run each of those scripts
- Add "RuleThemAll" script, which is using all of the scripts to list all services and presented them in the nice table