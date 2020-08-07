# First time deployment
Before the rest of the infrastructure can be deployed we need to ensure that the git repository is available and the code
it contains the application code. In order to do this, run:
```
terraform plan -target=module.repository -out init.plan
terraform apply "init.plan"
```
You can now remove the plan applied:
```
rm init.plan
```