# Multi-stage build - https://docs.docker.com/develop/develop-images/multistage-build/
FROM node:lts AS builder

WORKDIR /angular-app
COPY package.json .
COPY package-lock.json .
COPY angular.json .
COPY tsconfig.json .
COPY tslint.json .
COPY src/ ./src/

# Instead of npm install, needs package-lock.json - https://docs.npmjs.com/cli/ci.html
RUN npm ci
RUN npm run-script build-prod

FROM nginx:alpine

COPY --from=builder /angular-app/dist/tomcat-deployment-demo /usr/share/nginx/html
# Conf Nginx located at /etc/nginx/nginx.conf
# And... include /etc/nginx/conf.d/*.conf;
# Rewrite rules : https://www.nginx.com/blog/creating-nginx-rewrite-rules/
COPY nginx-conf/rewrite.conf /etc/nginx/conf.d/default.conf
