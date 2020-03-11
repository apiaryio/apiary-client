FROM ruby:2.4-alpine
RUN apk add --update build-base && rm /var/cache/apk/*
RUN gem install apiaryio
ENTRYPOINT ["apiary"]
