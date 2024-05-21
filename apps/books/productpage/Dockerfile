# Dockerfile

FROM node:16-alpine  

WORKDIR /app

COPY package*.json ./  

RUN npm install

COPY . .

# Use main file defined in package.json 
CMD [ "node", "productPage.js" ]