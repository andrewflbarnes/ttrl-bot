lambda = ttrl_discord_event_lambda.zip

.PHONY: build
build: $(lambda)

$(lambda): src/index.js
	zip -j $@ $<

.PHONY: clean
clean:
	rm -f $(lambda)