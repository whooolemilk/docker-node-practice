FROM node:18.16.0-alpine

ENV APP_ROOT /home/app

WORKDIR $APP_ROOT

COPY ./.yarnrc.yml ./package.json ./yarn.lock $APP_ROOT
COPY ./.yarn ./.yarn

RUN corepack enable
RUN yarn install
COPY . $APP_ROOT

EXPOSE 3000

CMD ["yarn", "dev"]