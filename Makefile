build:
	@docker compose build

bundle:
	@docker compose run --rm app bundle ${ARGS}

rspec:
	@docker compose run --rm app bundle exec rspec ${FILE}