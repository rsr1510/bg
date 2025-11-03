FROM node:18-alpine
WORKDIR /usr/src/app

# Copy dependency definitions first
COPY app/package*.json ./
RUN npm install --production

# Copy the rest of your application
COPY app/ .

EXPOSE 8080
CMD ["npm", "start"]
