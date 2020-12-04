# ttrl-bot

Using node 14.7.0

A discord bot for updating TTRL through the API (see ttrl-backend).

Requires the below passing through the env/.env
- BOT_TOKEN - the auth token for the bot this will run under
- API_TOKEN - the API token used on mutation operations (assumuing secure API is enabled in ttrl-backend)

The below optional tokens are also accepted
- LOG_LEVEL - (default info) one of error, warn, info, http, verbose, debug, silly
- API - (default ttrl-backend.herokuapp.com) the base path for the API

### Build

None required unless you want to build the docker container e.g.
```bash
docker build -t aflb/ttrl-bot .
```

### Run

With node
```bash
BOT_TOKEN=<token> API_TOKEN=<token> node main.js
```

With docker
```bash
docker run -it --name ttrl-bot -e LOG_LEVEL=verbose -e API_TOKEN=<token> -e BOT_TOKEN=<token>  aflb/ttrl-bot
```

### Deploy

The TTRL bot may be deployed and run through AWS EC2. Convenience terraform and ansible scripts are provided
for this.

##### AWS Infrastructure with Terraform

By default the terraform config will deploy a bitnami EC2 instance with support for node 14 and will emit the
public DNS for it.

```bash
cd terraform
terraform init
terraform plan -var-file default.tfvars     # ensure the public key is set as required or you won't be able to login!
terraform apply -var-file default.tfvars    # outputs the public DNS of the created EC2 instance
```

##### App Deployment with Ansible

A `pipenv` is provided for convenience if required.
```bash
pipenv install  # may take a while the first time for all deps
pipenv shell
```

The public DNS record obtained from terraform for the EC2 instance either needs setting in the host file or setting
at runtime. When running the install playbook prompts for required variables will be displayed e.g.
```bash
$ ansible-playbook -i hosts install.yml
Base URL of the backend API [https://ttrl-backend.herokuapp.com]:
Log level (error, warn, info, http, verbose, silly) [info]:
API token (leave empty to disaalow mutation operations):
BOT token (this is the auth token for the bot to authenticate against Discrod with):
```

The BOT token is required as this is the auth token used to log the bot into discord.  
The API token, while optional, is required for the bot to perform mutation operations (i.e. most operations other the
`!ttrl` and `!stats`).

Other playbooks:
- logs - output systemctl and bot logs
- restart - Force restart but nothing else
- update - Update to the latest version of the specified branch