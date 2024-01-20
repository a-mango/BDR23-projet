# Build stage
FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json .
COPY yarn*.lock .
RUN yarn install
COPY . .
RUN yarn build

# Deploy stage
FROM node:18-alpine
LABEL Name=frontend Version=0.0.1
WORKDIR /app
COPY --from=builder /app/build .
EXPOSE 80
CMD ["npx", "serve", "-s", ".", "-l", "80"]