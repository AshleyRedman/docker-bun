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

# Install dependencies into a temporary directory
FROM base AS install
RUN mkdir -p /temp/install
COPY package.json bun.lockb /temp/install/
RUN cd /temp/install && bun install --frozen-lockfile $( [ "$NODE_ENV" = "production" ] && echo "--production" )

# Final stage: Copy appropriate node_modules based on environment
FROM base AS final
COPY --from=dev /temp/install/node_modules node_modules

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
