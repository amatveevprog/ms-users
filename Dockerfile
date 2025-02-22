FROM makeomatic/node:$NODE_VERSION

ENV NCONF_NAMESPACE=MS_USERS \
    NODE_ENV=$NODE_ENV

WORKDIR /src

# pnpm fetch does require only lockfile
COPY pnpm-lock.yaml ./
RUN pnpm fetch --prod

COPY package.json ./
RUN \
  apk --update upgrade \
  && apk add git ca-certificates openssl g++ make python3 linux-headers \
  && pnpm install -r --offline --prod \
  && apk del \
    g++ \
    make \
    git \
    wget \
    python3 \
    linux-headers \
  && rm -rf \
    /tmp/* \
    /root/.node-gyp \
    /root/.npm \
    /etc/apk/cache/* \
    /var/cache/apk/*

COPY . /src
RUN  chown -R node /src
USER node
