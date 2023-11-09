rspec:
	@docker-compose run --rm app bundle exec rspec ${FILE_LIST}