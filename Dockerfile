FROM homeassistant/home-assistant:latest
MAINTAINER Timo Taskinen <timo.taskinen@iki.fi>

# Add Telldus repository
RUN echo "deb-src http://download.telldus.com/debian/ stable main" >> /etc/apt/sources.list.d/telldus.list
RUN wget http://download.telldus.se/debian/telldus-public.key
RUN apt-key add telldus-public.key
RUN rm telldus-public.key

# Install dependencies. Compile and install telldusd
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get build-dep -y telldus-core
RUN apt-get install -y cmake libconfuse-dev libftdi-dev help2man
RUN apt-get --compile source telldus-core
RUN dpkg --install *.deb

# Install and configure Supervisor
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]

# Specify health check
HEALTHCHECK CMD curl --fail http://localhost:8123 || exit 1
