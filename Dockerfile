FROM node:17-slim

WORKDIR /app

ADD yarn.lock .
ADD package.json .

RUN yarn

ADD . .

CMD ["yarn", "serve"]
