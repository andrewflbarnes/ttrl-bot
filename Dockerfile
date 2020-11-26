FROM node:14-alpine

RUN mkdir /app
WORKDIR /app

COPY package*.json ./

RUN npm install

COPY main.js .

ENV API=https://ttrl-backend.herokuapp.com

ENTRYPOINT [ "node", "main.js" ]