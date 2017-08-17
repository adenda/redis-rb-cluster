FROM ruby:2.4.1
WORKDIR /usr/local/bin
COPY . /usr/local/bin/

RUN chmod +x example.rb
RUN chmod +x run.sh
RUN chmod +x redis-trib.rb

RUN gem install redis

ENTRYPOINT ["./run.sh"]
