# Use official OpenJDK 21 slim image as base
FROM ghcr.io/pterodactyl/yolks:java_21

USER root
RUN apt-get update -y && apt-get install -y curl jq
USER container
# Set working directory
WORKDIR /home/container

# Copy the server start script
COPY t.sh /t.sh

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Expose Minecraft default port
EXPOSE 25565

# Set entrypoint to the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]