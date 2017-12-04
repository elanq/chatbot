FROM alpine:3.6

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base zlib-dev redis
ENV RUBY_PACKAGES  ruby ruby-io-console ruby-bundler ruby-rdoc ruby-irb

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES
#    rm -rf /var/cache/apk/*

#RUN apk update && apk upgrade && apk --update add \
#    ruby ruby-dev ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
#    libstdc++ tzdata bash ca-certificates zlib-dev\
#    &&  echo 'gem: --no-document' > /etc/gemrc
#RUN mkdir /usr/chatbot
WORKDIR /usr/chatbot

COPY Gemfile /usr/chatbot
COPY Gemfile.lock /usr/chatbot
RUN bundle install

COPY ./ /usr/chatbot
#RUN redis-cli -h 192.168.99.100 ping
ENTRYPOINT ["/usr/chatbot/run"]
