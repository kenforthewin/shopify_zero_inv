FROM ruby:2.3
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN mkdir -p /var/sockets
EXPOSE 3009
WORKDIR /app
COPY . .
CMD [ "deploy/start.sh" ]