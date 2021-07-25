FROM ruby:3.0

ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends build-essential libpq-dev postgresql-client \
      locales 

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN export LC_ALL="en_US.utf8"

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

COPY . $INSTALL_PATH

RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
