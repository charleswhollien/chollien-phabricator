FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /var/www 
COPY ./phab.sh /var/www/
WORKDIR /var/www
RUN apt-get update && apt-get install sudo -y && chmod a+x /var/www/phab.sh && /var/www/phab.sh
COPY phabricator.conf /etc/apache2/sites-enabled/000-default.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x /docker-entrypoint.sh
CMD /docker-entrypoint.sh
