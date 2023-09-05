# this is for Mac to ECR and ECS
FROM --platform=linux/arm64 node:18-alpine

WORKDIR /app

COPY package.json package-lock.json ./

RUN rm -f package-lock.json && npm install

COPY . ./

ARG MONGO_URL
ENV MONGO_URL="${MONGO_URL}"

ENV PORT="5000"
EXPOSE 5000

CMD [ "npm", "start" ]