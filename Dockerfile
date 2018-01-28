FROM ruby:2.3
ENV NGINX_VERSION 1.11.6-1~jessie
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list
ENV GPG_FINGERPRINT=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys ${GPG_FINGERPRINT} \
  || apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys ${GPG_FINGERPRINT}
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -y nginx=${NGINX_VERSION} nodejs
RUN mkdir -p /var/sockets
EXPOSE 80
COPY ./deploy/default.conf /etc/nginx/conf.d/default.conf
WORKDIR /app
COPY . .
CMD [ "deploy/start.sh" ]