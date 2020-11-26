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