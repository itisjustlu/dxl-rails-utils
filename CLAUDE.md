# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DXL Rails Utils is a Ruby gem (v4.0.2) providing modular Rails utilities: interactor pattern, ActiveRecord query builder, HTTP client wrapper, JSON schema generation, and token generation. It's a Rails engine requiring Ruby 3.4.7 and Rails/ActiveSupport >= 8.

## Commands

```bash
# Docker-based development
make build                          # Build Docker image
make bundle ARGS="install"          # Install dependencies
make rspec                          # Run all tests
make rspec FILE=spec/lib/dxl/ar/finder_spec.rb  # Run single test file

# Local development
bundle install
bundle exec rspec
bundle exec rspec spec/lib/dxl/ar/finder_spec.rb
```

## Architecture

Entry point is `lib/dxl.rb`. The gem is organized into five main subsystems:

### Services + Modules (Composable Behavior)

`DXL::Services::ApplicationService` is the base class. Services declare capabilities via `behave_as`:

```ruby
class MyService < ::DXL::Services::ApplicationService
  behave_as :interactor, :client
end
```

This dynamically includes `InteractorModule`, `ClientModule`, etc. from `lib/dxl/modules/`.

### Interactor Pattern (`lib/dxl/modules/interactor_module.rb`)

Built on the `interactor` gem's Organizer. Key DSL methods:
- `organize` — sequential interactor chain
- `organize_if` — conditional execution with `:condition` lambda
- `required_context` — validates context keys, raises `MissingContextError`
- `delegate_to_context` — delegates methods to context

### AR Finder (`lib/dxl/ar/finder.rb`)

Query builder using concerns in `lib/dxl/ar/concerns/finders/`:
- **Comparison** — `find_eq`, `find_not_eq`, `find_gte`, `find_gt`, `find_lte`, `find_lt`, `find_ilike`
- **Associations** — `including`, `joining`, `left_joining`, `associating`
- **Pagination** — page/per_page with configurable defaults via `DXL::AR::Configuration`
- **Order** — column + direction sorting
- Custom finders via `find ->(relation, opts) { ... }, only_if: ->(opts) { ... }`

### HTTP Client (`lib/dxl/modules/client_module.rb`)

Faraday wrapper providing `do_get_request`, `do_post_request`, `do_patch_request`, `do_put_request`, `do_delete_request`. Services override `url`, `headers`, `params`, `body` methods. Response checked via `successful?`, `client_error?`, `server_error?`, etc.

### JSON Schema Generation (`lib/dxl/schemas/`)

`DXL::Schemas::Builder` generates JSON Schema from `JSONAPI::Serializer` classes. Delegates to `AttributesBuilder`, `RelationshipsBuilder`, `SerializedBuilder`, and `IncludedBuilder`.

## Code Conventions

- All files use `# frozen_string_literal: true`
- Module inclusion pattern: `self.included(base)` with `ClassMethods`/`InstanceMethods` submodules
- Test specs mirror source paths: `lib/dxl/ar/finder.rb` → `spec/lib/dxl/ar/finder_spec.rb`
- Tests use SQLite3 in-memory database with DatabaseCleaner (transaction strategy)
- Version managed in `dxl-rails-utils.gemspec`, releases tagged as `vX.Y.Z`
