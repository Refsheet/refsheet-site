# Base image
FROM nginx
# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils
# establish where Nginx should look for files
ARG rails_container
ARG port
ARG rails_port

ENV PORT $port
ENV RAILS_CONTAINER $rails_container
ENV RAILS_PORT $rails_port
ENV RAILS_ROOT /app
# Set our working directory inside the image
WORKDIR $RAILS_ROOT
# create log directory
RUN mkdir log
# copy over static assets
COPY public public/
# Copy Nginx config template
COPY .nginx/nginx.conf /tmp/docker.nginx
# substitute variable references in the Nginx config template for real values from the environment
# put the final config in its place
RUN envsubst '$RAILS_ROOT:$RAILS_PORT:$PORT:$RAILS_CONTAINER' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf
EXPOSE $port
# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
