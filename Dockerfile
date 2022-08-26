FROM ruby:2.5.1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /app

ENV APP_ROOT /app

WORKDIR $APP_ROOT

COPY ./Gemfile $APP_ROOT/Gemfile

COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install

COPY . $APP_ROOT