# FROM --platform=linux/amd64 node:18-alpine # this is for Mac to ECR and ECS
FROM node:18-alpine 
WORKDIR /app
COPY package.json package-lock.json ./
RUN rm -f package-lock.json && npm install
COPY . ./
EXPOSE 5000
CMD [ "npm", "start" ]