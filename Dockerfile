# this is for Mac to ECR and ECS
FROM --platform=linux/arm64/v8 node:18-alpine
# FROM node:18-alpine 
WORKDIR /app
COPY package.json package-lock.json ./
RUN rm -f package-lock.json && npm install
COPY . ./
EXPOSE 5000
CMD [ "npm", "start" ]