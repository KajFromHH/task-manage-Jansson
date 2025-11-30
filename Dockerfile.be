# Dockerfile for backend.
# Sever for React application.

# Development stage.

# Note that we need all required environment variables
# for backend (EVFB). However, since container will read
# EVFB at runtime, we can set EVFB in docker-compose.yml file.

FROM node:25-alpine AS backend-build
WORKDIR /backend
COPY package*.json ./
RUN npm install
COPY ./backend ./
RUN npm run build

# Test stage
FROM node:25-alpine AS backend-test
WORKDIR /backend
COPY --from=backend-build /backend ./
RUN npm run test

# Production stage
FROM node:25-alpine AS production
COPY --from=backend-build /backend/build ./
CMD ["npm", "start"]