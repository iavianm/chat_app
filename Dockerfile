FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client netcat-openbsd

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
COPY wait-for /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
