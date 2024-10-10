# Use the official Bun base image (Alpine version)
FROM oven/bun:1-alpine AS base

# Update package index and upgrade system packages
RUN apk update && apk upgrade --no-cache

# Install tzdata to manage timezones
RUN apk add --no-cache tzdata

# Set the timezone to UTC
ENV TZ=UTC

# Set the working directory
WORKDIR /usr/src/app

# Install dependencies into a temporary directory for development dependencies
FROM base AS install
RUN mkdir -p /temp/dev
COPY package.json bun.lockb /temp/dev/
RUN cd /temp/dev && bun install --frozen-lockfile

# Install production dependencies into a separate temporary directory
FROM base AS prod
RUN mkdir -p /temp/prod
COPY package.json bun.lockb /temp/prod/
RUN cd /temp/prod && bun install --frozen-lockfile --production

# Final stage: Copy appropriate node_modules based on environment
FROM base AS final

# Choose to copy either dev or prod node_modules based on NODE_ENV
# Copy the entire node_modules from the appropriate stage
# COPY --from=install /temp/dev/node_modules node_modules
# Alternatively, you could use the following for production-only build:
COPY --from=prod /temp/prod/node_modules node_modules

# Copy all the application files into the final image
COPY . .

# Set default environment variable for NODE_ENV (production by default)
ENV NODE_ENV=production

# Expose the necessary port
EXPOSE 3000/tcp

# Define the ENTRYPOINT to use bun for starting the app
# ENTRYPOINT ["bun", "start"]

# CMD based on the value of NODE_ENV: 'bun dev' for development, 'bun start' for production
CMD ["sh", "-c", "if [ \"$NODE_ENV\" = \"development\" ]; then bun dev; else bun start; fi"]
