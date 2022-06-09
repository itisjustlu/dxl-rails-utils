# ::DXL::AR::Finder

AR::Finder class provides a simple interface to create powerful queries without
reusing code or creating useless and boilerplate files.

* [Getting started](#getting-started)
* [Find method](#find-method)
* [Comparison Module](#comparison-module)
* [Associations](#associations)
  * [Associating method](#associating-method)
* [Pagination](#pagination)
* [Order](#order)

### Getting Started
AR::Finder implements interactor pattern. So the result you will receive will
be in a context `OpenStruct`

First you need to define the basic object to query and the key for returning data

```ruby
class Question < ApplicationRecord
  belongs_to :organization
end

class Organization < ApplicationRecord
  has_many :questions
end

class Questions::Finder < ::DXL::AR::Finder
  before do
    context.object_class = Question
    context.key = :questions
  end
end

result = Questions::Finder.call
render json: result.questions
```

You can also use scoped query

```ruby
class Questions::Finder < ::DXL::AR::Finder
  before do
    context.object_class = context.organization.questions
    context.key = :questions
  end
end

result = ::Questions::Finder.call(organization: Organization.last)
```

### find method
Its possible to write custom find methods based in custom opts. Imagine
you want to find organizations when questions.title matchs something. But
you only want to find this if a given opts is passed to the service
```ruby
class Organizations::Finder < ::DXL::AR::Finder
  before do
    context.object_class = ::Organization
    context.key = :organizations
  end
  
  joining :questions
  find ->(relation, opts) { relation.where(questions: { title: opts[:question_title] }) },
       only_if: ->(opts) { opts[:question_title].present? }
end

result = Organizations::Finder.call(opts: { question_title: 'Test' })
```

### Comparison module
Comparison module provides a simple way to find by a given attribute

#### Eq
```ruby
class Questions::Finder < ::DXL::AR::Finder
  before do
    ...
  end
  
  find_eq :title
end

result = Questions::Finder.call(opts: { title_eq: 'Test' })
```

This will return all questions when title is equal to `Test`.

#### Greater or Lower than / Greater equal or Lower equal to

You can find by this options, column parameter is optional. If missing, it will use
the same column as first param
```ruby
class Questions::Finder < ::DXL::AR::Finder
  before do
    ...
  end
  
  find_gte :created_at, column: :created_at
  find_gt :created_at, column: :created_at
  find_lte :created_at, column: :created_at
  find_lt :created_at, column: :created_at
end

result = ::Questions::Finder.call(otps: { created_at_gte: 5.days.ago, created_at_lte: Time.now })
```

### Associations
Associations are being performed by adding simple attributes to the class. If you want
to avoid n+1 queries or add custom joins

```ruby
class ::Questions::Finder < ::DXL::AR::Finder
  before do
    ...
  end
  
  including :organization # add includes(:organization) to active record query
  joining :organization # add joins(:organization) to active record query
  left_joining :organization # add left_joins(:organization) to active record query
end
```

#### Associating method
This method will add `where.associated(:relation)` to the active record query.
Its basically for find records when relation is present in the right side. 
Imagine you want to find organizations with questions attached.

```ruby
class Organizations::Finder < ::DXL::AR::Finder
  before do
    context.object_class = ::Organization
    context.key = :organizations
  end
  
  associating :questions
end

result = Organizations::Finder.call(opts: { with_questions: true })
```

If `with_questions` option is passed, it will only load organizations with questions.
Otherwise will load all the organizations

### Pagination
By default, AR::Finder paginates using `page` parameter. It does not allow to retrieve all records
at once. So you will always return paginated items
```ruby
result = Questions::Finder.call(opts: { page: 2 })
```

### Order
By default, AR::Finder will order by `id: :desc`, you can change this behavior passing
custom opts
```ruby
opts = { order: :title, direction: :asc }
result = Questions::Finder.call(opts: opts)
```