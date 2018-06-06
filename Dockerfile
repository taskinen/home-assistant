# Take the base image as build
FROM homeassistant/home-assistant:latest as build

MAINTAINER timo.taskinen@iki.fi
LABEL maintainer "Timo Taskinen <timo.taskinen@iki.fi>"

# Specify working directory
WORKDIR /usr/src/app

# Add Telldus repository to apt
RUN echo "deb-src http://download.telldus.com/debian/ unstable main" >> /etc/apt/sources.list.d/telldus.list
RUN curl -sSL http://download.telldus.com/debian/telldus-public.key | apt-key add -

# Install dependencies. Compile and install telldusd
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get build-dep -y telldus-core
RUN apt-get install -y cmake libconfuse-dev libftdi-dev help2man
RUN apt-get --compile source telldus-core

# Take a new clean base image
FROM homeassistant/home-assistant:latest

# Specify working directory
WORKDIR /tmp/telldusd

# Copy the compiled packages from the build image
COPY --from=build /usr/src/app/*.deb /tmp/telldusd/

# Install the telldusd packages and their dependencies
RUN apt-get update && apt-get install -y libconfuse-dev libftdi-dev
RUN dpkg --install *.deb
RUN rm -rf /tmp/telldusd

# Install and configure Supervisor
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]

# Clean caches
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Specify health check for Docker
HEALTHCHECK CMD curl --fail http://localhost:8123 || exit 1
