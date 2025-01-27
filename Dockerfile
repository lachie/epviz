FROM node:20-bookworm-slim AS build

RUN apt-get -y update && apt-get install -y --no-install-recommends libsqlite3-dev

WORKDIR /build
ADD . /build
RUN rm -rf /build/node_modules && npm i
ENV \
  DB_PATH=/data/epviz.sqlite \
  SHOW_DB_PATH=/data/shows.sqlite
RUN --mount=type=bind,dst=/data,source=./data npm run build


FROM node:20-bookworm-slim

# RUN apt-get -y update && apt-get install -y --no-install-recommends libsqlite3-dev

WORKDIR /app
ADD package.json package-lock.json .

RUN npm ci --omit dev

COPY --from=build /build/build /app

CMD ["node", "."]
