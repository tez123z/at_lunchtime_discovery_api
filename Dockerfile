FROM ruby:2.7.2

RUN apt-get update -qq && apt-get install -y postgresql-client
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN ["chmod", "+x", "./docker/startup.sh"]
RUN ["chmod", "+x", "./docker/wait-for-services.sh"]
RUN ["chmod", "+x", "./docker/prepare-db.sh"]
ENTRYPOINT ["./docker/startup.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]