FROM coopermaa/alpine-ruby:2.2
RUN apk add --update build-base && rm /var/cache/apk/*
RUN gem install apiaryio
ENTRYPOINT ["apiary"]
