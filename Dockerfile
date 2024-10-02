# Dockerfile
FROM node:20 AS build-env

# Copy files and folders to the working directory
COPY . /app

# Set the working directory
WORKDIR /app

# Install dependencies
RUN sudo npm ci --omit=dev

# Use "Distroless" Container Images" https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/nodejs20-debian12

# Copy all from build-env to distro
COPY --from=build-env /app /app

# Set the working directory
WORKDIR /app

# Build the Next.js application for production
RUN sudo npm run build
# Set the environment variable to run the Next.js application in production mode
ENV NODE_ENV production
ENV PORT 8090

# Expose the port that the application will run on
EXPOSE 8090

# Run NextJS app
CMD ["npm", "start"]