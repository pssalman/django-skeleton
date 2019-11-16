# Pull base image
FROM python:3.6-alpine AS build

LABEL version="1.0" \
      description="django app base image" \
      stage="build" \
      maintainer="Anton Salman <anton.salman@gmail.com>"

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# This is where pip will install to
ENV PYROOT /pyroot
# A convenience to have console_scripts in PATH
ENV PATH $PYROOT/bin:$PATH
ENV PYTHONUSERBASE $PYROOT

RUN apk add --no-cache --virtual .build-deps \
      gcc \
      build-base \
      python3-dev \
      postgresql-dev \
      linux-headers \
      libc-dev \
      fortify-headers

# Install dependencies & Virtual Environment Package Management

RUN pip install --upgrade pip \
      setuptools \
      wheel \
      pipenv

WORKDIR /build

COPY ./Pipfile* ./

#RUN pipenv install --deploy --system --dev
#RUN pipenv install --deploy --system --clear
RUN PIP_USER=1 PIP_IGNORE_INSTALLED=1 pipenv install --system --deploy

RUN apk del .build-deps \
      && rm -rf /root/.cache/pip/*

# Pull base image
FROM python:3.6-alpine

LABEL version="1.0" \
      description="django app base image" \
      stage="deploy" \
      maintainer="Anton Salman <anton.salman@gmail.com>"

# Available Options - dev and prod
ARG ENV
ENV ENV ${ENV}
ARG PORT=8000
ENV PORT ${PORT}
ARG BUILD_NUMBER
ARG COMMIT_HASH
ARG PROJECT_NAME
ENV PROJECT_NAME ${PROJECT_NAME}
ENV BUILD_NUMBER ${BUILD_NUMBER}
ENV COMMIT_HASH ${COMMIT_HASH}

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PYROOTBUILD /pyroot
ENV PYROOT /app/pyroot
ENV PATH $PYROOT/bin:$PATH

ENV PYTHONPATH $PYROOT/lib/python3.6:$PATH
ENV PATH $PYROOT/lib/python3.6/site-packages:$PATH

# This is crucial for pkg_resources to work
ENV PYTHONUSERBASE $PYROOT

ARG ADMIN_PASSWORD
ENV ADMIN_PASSWORD ${ADMIN_PASSWORD}

# Create user to run app
RUN addgroup -g 1000 -S django && \
      adduser -u 1000 -S django -G django

# Set work directory
RUN mkdir -p /app/src /app/pyroot \
      && chown -R django:django /app/src \
      && chown -R django:django /app/pyroot

# Finally, copy artifacts
COPY --from=build --chown=django:django $PYROOTBUILD/lib/ $PYROOT/lib/
COPY --from=build --chown=django:django $PYROOTBUILD/bin/ $PYROOT/bin/

WORKDIR /app/src

# install systemc dependencies
RUN apk add --no-cache --upgrade \
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
      gettext \
      libpq \
      postgresql-client \
      netcat-openbsd \
      && apk add --no-cache --upgrade \
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
      geos \
      proj \
      gdal \
      && ln -s /usr/lib/libproj.so.13 /usr/lib/libproj.so \
      && ln -s /usr/lib/libgdal.so.20 /usr/lib/libgdal.so \
      && ln -s /usr/lib/libgeos_c.so.1 /usr/lib/libgeos_c.so \
      && rm -rf /var/cache/apk/*

# copy entrypoint.sh
COPY --chown=django:django ./entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Copy project
COPY --chown=django:django ./src /app/src

USER django

# run entrypoint.sh
# ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/entrypoint.sh"]