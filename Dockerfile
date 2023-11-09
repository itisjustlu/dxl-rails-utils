FROM ruby:3.2.2

ENV INSTALL_PATH /app
ENV BUNDLE_PATH /gems
ENV GEM_HOME /gems

WORKDIR $INSTALL_PATH
COPY ./Gemfile ./Gemfile.lock ./rails_utils.gemspec $INSTALL_PATH/
RUN gem install bundler -v '2.3.26'
RUN bundle install
COPY . .