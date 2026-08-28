FROM node:20-alpine AS build

WORKDIR /app

COPY signal-app/package*.json ./

RUN npm install --production

COPY signal-app/ .

RUN npm run build


FROM nginx:alpine

COPY signal-app/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build app/www/browser /usr/share/nginx/html

EXPOSE 80
