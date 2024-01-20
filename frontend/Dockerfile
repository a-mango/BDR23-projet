# Build stage
FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

# Deploy stage
FROM node:18-alpine
LABEL Name=frontend Version=0.0.1
WORKDIR /app
COPY --from=builder /app/build .
EXPOSE 80
CMD ["npx", "serve", "-s", ".", "-l", "80"]