FROM nginx:alpine

LABEL version="1.0" \
      description="nginx proxy web image" \
      stage="deploy" \
      maintainer="Anton Salman <anton.salman@gmail.com>"

ARG ENV
ENV ENV ${ENV}
ARG BUILD_NUMBER
ARG COMMIT_HASH
ARG PROJECT_NAME
ENV PROJECT_NAME ${PROJECT_NAME}
ENV BUILD_NUMBER ${BUILD_NUMBER}
ENV COMMIT_HASH ${COMMIT_HASH}

#RUN rm /usr/share/nginx/html/
RUN rm /etc/nginx/conf.d/default.conf

COPY sites-enabled/default /etc/nginx/conf.d/default.conf