FROM alpine

ENV PROJECT_DIR=/data/src

RUN apk update && apk add --no-cache build-base ruby ruby-bundler ruby-dev nodejs mariadb-dev npm git curl tzdata zlib zlib-dev && \
rm -rf /var/cache/apk/*

RUN npm install -g bower

WORKDIR $PROJECT_DIR

COPY Gemfile Gemfile.lock bower.json $PROJECT_DIR/
RUN bundle install
RUN bower install --allow-root

COPY . $PROJECT_DIR/
RUN bundle exec rake assets:precompile

EXPOSE 3000

ENTRYPOINT [ "./docker/entrypoint" ]
CMD [ "start" ]
