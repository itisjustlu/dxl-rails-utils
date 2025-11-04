FROM ruby:3.4.7

ENV INSTALL_PATH /app
ENV BUNDLE_PATH /gems
ENV GEM_HOME /gems

WORKDIR $INSTALL_PATH
COPY ./Gemfile  ./dxl-rails-utils.gemspec $INSTALL_PATH/
RUN gem install bundler -v '2.7.2'
RUN bundle install
COPY . .