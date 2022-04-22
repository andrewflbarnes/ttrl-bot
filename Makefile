lambda = ttrl_discord_event_lambda.zip
lambda_layer = ttrl_discord_event_lambda_deps.zip

.PHONY: build
build: $(lambda_layer) $(lambda)

$(lambda): src/index.js
	zip -X9qj $@ $<

$(lambda_layer): node_modules build/nodejs/node_modules/
	rm -f $@
	zip -X9qr $@ build

node_modules: package.json package-lock.json
	rm -rf node_modules/*
	npm install --production
	touch node_modules

build/nodejs/node_modules:
	mkdir -p build/nodejs
	[ ! -e build/nodejs/node_modules ] && ln -s $$(pwd)/node_modules build/nodejs/node_modules

.PHONY: clean
clean:
	rm -f $(lambda_layer) $(lambda)