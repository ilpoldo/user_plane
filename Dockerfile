FROM ruby:2.3.1

# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
# RUN apt-get install -y nodejs

RUN mkdir -p /usr/src/gem
WORKDIR /usr/src/gem

ADD . /usr/src/gem

ENV BUNDLE_JOBS=4

# TODO: add the dependencies to the image for speed?
ENV BUNDLE_PATH=vendor/bundle

RUN bundle check || bundle install

