FROM node:12-alpine3.12 as builder

LABEL mainteiner="metacringer@gmail.com"
RUN addgroup -g 2021 user  && adduser user -D -u 2021 -G user 
USER user
COPY --chown=user:user package.json /app/
WORKDIR /app

RUN npm install


FROM node:12-alpine3.12
RUN npm i -g serve
RUN addgroup -g 2021 user  && adduser user -D -u 2021 -G user

COPY --chown=user:user . /app
COPY --from=builder --chown=user:user /app/node_modules /app/node_modules

USER user
WORKDIR /app
RUN npm run build

HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:4100 || exit 1
ENV TZ=Europe/Kyiv
ENTRYPOINT exec serve -s -l 4100 build  
