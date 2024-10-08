# Dockerfile
FROM node:20 AS build-env

# Disable telemetry
ENV NEXT_TELEMETRY_DISABLED 1

# Copy files and folders to the working directory
COPY . /app

# Set the working directory
WORKDIR /app

# Set the environment variable to run the Next.js application in production mode
ENV NODE_ENV production

# Install dependencies
RUN npm ci --include=dev

# Copy files. Use dockerignore to avoid copying node_modules
COPY . .

# Build the Next.js application for production
RUN npm run build

# Use "Distroless" Container Images" https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/nodejs20-debian12

# Copy all from build-env to distro
COPY --from=build-env /app /app

# Set the working directory
WORKDIR /app

# Set the environment variable to run the Next.js application in production mode
ENV NODE_ENV production
ENV PORT 80
ENV NEXT_TELEMETRY_DISABLED 1

# Expose the port that the application will run on
EXPOSE 80
EXPOSE 443

# Run NextJS app
CMD ["./node_modules/next/dist/bin/next", "start"]