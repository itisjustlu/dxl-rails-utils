# DXL Rails Utils

A collection of Rails utilities: AR query builder, interactor pattern, HTTP client wrapper, and more.

Requires Ruby 3.4+ and Rails/ActiveSupport >= 8.

## Install

```ruby
gem 'dxl', git: 'https://github.com/itslujuarez/dxl-rails-utils.git', tag: 'v5.0.0', require: 'dxl'
```

Then run `bundle install`.

---

## Table of Contents

- [AR::Finder](#arfinder)
  - [Getting Started](#getting-started)
  - [Comparison](#comparison)
  - [Associations](#associations)
  - [Pagination](#pagination)
  - [Order](#order)
  - [Custom Finders](#custom-finders)
  - [Configuration](#configuration)
- [Interactor](#interactor)
- [HTTP Client](#http-client)

---

## AR::Finder

`DXL::AR::Finder` is a query builder that composes filtering, associations, pagination, and ordering in a single class. It uses the interactor pattern — results come back in a context object.

### Getting Started

Define a finder class with `object_class` (the model to query) and `key` (the context attribute where results are stored):

```ruby
class Questions::Finder < DXL::AR::Finder
  before do
    context.object_class = Question
    context.key = :questions
  end
end

result = Questions::Finder.call(opts: {})
result.questions # => ActiveRecord::Relation
```

You can also scope the query to an association:

```ruby
class Questions::Finder < DXL::AR::Finder
  before do
    context.object_class = context.organization.questions
    context.key = :questions
  end
end

result = Questions::Finder.call(organization: Organization.find(1), opts: {})
```

---

### Comparison

Declare which fields are queryable. Only declared fields are allowed — any other key in `opts` is ignored, which prevents arbitrary ransack predicates from being passed by callers.

Internally, comparison uses [ransack](https://github.com/activerecord-hackery/ransack). Models must declare `ransackable_attributes` and `ransackable_associations` (ransack requirement):

```ruby
class Organization < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[id title created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[questions]
  end
end
```

#### find_eq

Exact match. Opts key: `{field}_eq`.

```ruby
class Organizations::Finder < DXL::AR::Finder
  before { context.object_class = Organization; context.key = :organizations }

  find_eq :title
end

Organizations::Finder.call(opts: { title_eq: 'Acme' })
```

#### find_not_eq

Excludes exact match. Opts key: `{field}_not_eq`.

```ruby
find_not_eq :title

Organizations::Finder.call(opts: { title_not_eq: 'Acme' })
```

#### find_ilike

Case-insensitive partial match (equivalent to SQL `ILIKE`). Opts key: `{field}_i_cont`.

```ruby
find_ilike :title

Organizations::Finder.call(opts: { title_i_cont: 'acme' })
```

#### find_gte / find_gt / find_lte / find_lt

Range comparisons. The `column:` option is optional — defaults to the field name.

| Method | Opts key | SQL |
|--------|----------|-----|
| `find_gte :created_at` | `created_at_gteq` | `>= value` |
| `find_gt :created_at` | `created_at_gt` | `> value` |
| `find_lte :created_at` | `created_at_lteq` | `<= value` |
| `find_lt :created_at` | `created_at_lt` | `< value` |

```ruby
class Organizations::Finder < DXL::AR::Finder
  before { context.object_class = Organization; context.key = :organizations }

  find_gte :created_at
  find_lte :created_at
end

Organizations::Finder.call(opts: { created_at_gteq: 7.days.ago, created_at_lteq: Time.now })
```

#### Filtering by associated table columns

Declare `find_ilike` with the ransack joined-table format (`{association}_{column}`). This enables filtering across associations without manually writing joins.

```ruby
class Organizations::Finder < DXL::AR::Finder
  before { context.object_class = Organization; context.key = :organizations }

  find_ilike :questions_title
end

# Returns organizations that have a question with "billing" in the title
Organizations::Finder.call(opts: { questions_title_i_cont: 'billing' })
```

---

### Associations

Avoid N+1 queries or add joins at the class level:

```ruby
class Questions::Finder < DXL::AR::Finder
  before { context.object_class = Question; context.key = :questions }

  including :organization       # adds includes(:organization)
  joining :organization         # adds joins(:organization)
  left_joining :organization    # adds left_joins(:organization)
end
```

#### associating

Filters records that have a related record present. Opts key: `with_{association}: true`.

```ruby
class Organizations::Finder < DXL::AR::Finder
  before { context.object_class = Organization; context.key = :organizations }

  associating :questions
end

# Returns only organizations that have at least one question
Organizations::Finder.call(opts: { with_questions: true })

# Returns all organizations
Organizations::Finder.call(opts: {})
```

---

### Pagination

Results are paginated by default. Without `page`, all records are returned. Pass `page` to paginate.

```ruby
result = Questions::Finder.call(opts: { page: 2, per: 10 })

result.questions    # => records for page 2
result.page         # => 2
result.per_page     # => 10
```

Pass `count: true` to get total pages:

```ruby
result = Questions::Finder.call(opts: { page: 1, per: 10 }, count: true)

result.total_items  # => 42
result.total_pages  # => 5
```

---

### Order

Default order is `id: :desc`. Override with `order` and `direction` opts:

```ruby
Questions::Finder.call(opts: { order: :title, direction: :asc })
```

Use ransack's `s` param for multi-column or complex sorting:

```ruby
Questions::Finder.call(opts: { s: 'title asc' })
```

---

### Custom Finders

Use `find` for custom query logic not covered by the built-in comparisons. Use `only_if:` to conditionally apply it:

```ruby
class Organizations::Finder < DXL::AR::Finder
  before { context.object_class = Organization; context.key = :organizations }

  find ->(relation, opts) { relation.where(status: opts[:status]) },
       only_if: ->(opts) { opts[:status].present? }
end

Organizations::Finder.call(opts: { status: 'active' })
```

---

### Configuration

Set a global default `per_page` (default is 20):

```ruby
# config/initializers/dxl.rb
DXL::AR::Configuration.configure do |config|
  config.per_page = 25
end
```

---

## Interactor

`DXL::Services::ApplicationService` is the base class for services. Add behavior with `behave_as`:

```ruby
class MyService < DXL::Services::ApplicationService
  behave_as :interactor
end
```

### organize

Chain interactors sequentially:

```ruby
class Orders::Creator < DXL::Services::ApplicationService
  behave_as :interactor

  organize ValidateOrder, ChargePayment, SendConfirmation
end

result = Orders::Creator.call(order: order)
```

### organize_if

Conditionally include interactors in the chain:

```ruby
organize_if SendSmsNotification,
            condition: ->(ctx) { ctx.user.phone.present? }
```

### required_context

Raise `DXL::Errors::Interactors::MissingContextError` if a required context key is missing:

```ruby
class Invoices::Creator < DXL::Services::ApplicationService
  behave_as :interactor

  required_context :organization, :user

  def call
    # guaranteed: context.organization and context.user are present
  end
end
```

### delegate_to_context

Shorthand for accessing context attributes as methods:

```ruby
delegate_to_context :user, :organization

def call
  user.update!(...)   # same as context.user.update!(...)
end
```

---

## HTTP Client

`DXL::Modules::ClientModule` is a Faraday wrapper. Add it via `behave_as :client`.

### Setup

Create a base client class:

```ruby
# app/lib/application_client.rb
class ApplicationClient < DXL::Services::ApplicationService
  behave_as :client
end
```

Convention for naming client classes:

```
GET  /comments       => Clients::Comments::Finder
GET  /comments/:id   => Clients::Comments::Retriever
POST /comments       => Clients::Comments::Creator
PUT  /comments/:id   => Clients::Comments::Updater
DELETE /comments/:id => Clients::Comments::Destroyer
```

### GET request

```ruby
class Clients::Comments::Finder < ApplicationClient
  def call
    do_get_request
  end

  private

  def url
    'https://jsonplaceholder.typicode.com/comments'
  end

  def params
    { limit: 20, page: 1 }
  end
end

client = Clients::Comments::Finder.new
client.call

client.body    # => parsed JSON response
client.status  # => 200
```

### POST request

```ruby
class Clients::Comments::Creator < ApplicationClient
  def initialize(payload)
    @payload = payload
  end

  def call
    do_post_request
  end

  private

  def url
    'https://jsonplaceholder.typicode.com/comments'
  end

  def body_params
    @payload
  end
end

client = Clients::Comments::Creator.new({ name: 'Lu', email: 'lu@lu.com' })
client.call
client.status # => 201
```

`body_params` are sent as `application/json`.

### Available HTTP methods

```ruby
do_get_request
do_post_request
do_patch_request
do_put_request
do_delete_request
```

### Headers

```ruby
private

def headers
  { 'Authorization' => "Bearer #{token}" }
end
```

### Response helpers

```ruby
client.successful?    # 2xx
client.client_error?  # 4xx
client.server_error?  # 5xx
```
