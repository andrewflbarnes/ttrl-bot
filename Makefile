lambda = ttrl_discord_event_lambda.zip
lambda_layer = ttrl_discord_event_lambda_deps.zip

.PHONY: build
build: $(lambda_layer) $(lambda)

$(lambda): src/index.js
	zip -j $@ $<

$(lambda_layer): package.json package-lock.json build/nodejs/node_modules
	zip -r $@ build

build/nodejs/node_modules:
	npm install --production
	mkdir -p build/nodejs
	mv node_modules build/nodejs/

.PHONY: clean
clean:
	rm -rf node_modules
	rm -rf build/nodejs/node_modules
	rm -f $(lambda_layer) $(lambda)