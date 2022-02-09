# syntax=docker/dockerfile:1.3
ARG  NODE_VERSION=14
FROM node:${NODE_VERSION}-alpine as BUILDER

WORKDIR /app
COPY package.json yarn.lock ./
# Install dependencies
RUN --mount=type=cache,target=/root/.yarn YARN_CACHE_FOLDER=/root/.yarn yarn --frozen-lockfile

FROM node:${NODE_VERSION}-alpine

ENV NODE_ENV=production
WORKDIR /app
COPY --from=BUILDER /app/node_modules ./node_modules
COPY package.json yarn.lock ./
COPY . .

CMD [ "yarn", "start" ]