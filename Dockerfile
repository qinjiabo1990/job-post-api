FROM --platform=linux/amd64 node:18-alpine
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . ./
EXPOSE 5000
CMD [ "npm", "start" ]