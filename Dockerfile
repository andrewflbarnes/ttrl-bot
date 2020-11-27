FROM node:14-alpine

RUN mkdir /app
WORKDIR /app

COPY package*.json ./

RUN npm install

ADD src src

ENV API=https://ttrl-backend.herokuapp.com

ENTRYPOINT [ "node", "src" ]
