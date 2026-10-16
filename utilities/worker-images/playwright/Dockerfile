# Execution container image for Octopus workers.
# Node.js LTS, Playwright with Chromium and Firefox, and common shell tooling.
#
# Build and push (replace the tag and Docker Hub user):
#   docker build -t <dockerhub-user>/octopus-worker-playwright:1.0.0 .
#   docker push <dockerhub-user>/octopus-worker-playwright:1.0.0

# Base image for the worker tools. Confirm this image and its tag on Docker Hub before building.
ARG BASE_IMAGE=octopuslabs/workertools
FROM --platform=linux/amd64 ${BASE_IMAGE}

ARG NODE_MAJOR=22
ARG PLAYWRIGHT_VERSION=1.64.1
# Pin npm so the image doesn't drift to a new major version on rebuild.
ARG NPM_VERSION=10.9.9

ENV DEBIAN_FRONTEND=noninteractive \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright \
    NODE_PATH=/usr/local/lib/node_modules \
    NPM_CONFIG_UPDATE_NOTIFIER=false

USER root

# Common shell and scripting tools.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      wget \
      git \
      jq \
      unzip \
      zip \
      rsync \
      gettext-base \
      shellcheck \
      python3 \
 && rm -rf /var/lib/apt/lists/*

# Node.js LTS from NodeSource.
RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && npm install -g "npm@${NPM_VERSION}" \
 && rm -rf /var/lib/apt/lists/*

# Playwright, the test runner, and browsers with their system dependencies.
# Global installs are visible to projects through NODE_PATH. Project-specific
# packages still come from `npm install` in each project.
RUN npm install -g "playwright@${PLAYWRIGHT_VERSION}" "@playwright/test@${PLAYWRIGHT_VERSION}" \
 && npx playwright install --with-deps chromium firefox \
 && chmod -R a+rX "${PLAYWRIGHT_BROWSERS_PATH}" \
 && npm cache clean --force \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /var/cache/apt/* /root/.npm /root/.cache /tmp/* \
           /usr/share/doc /usr/share/man /usr/share/info /usr/share/locale/*

RUN node --version && npm --version && jq --version && git --version && playwright --version
