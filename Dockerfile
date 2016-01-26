FROM coopermaa/alpine-ruby:2.2-onbuild]
RUN gem install apiaryio
ENTRYPOINT ["apiary"]
