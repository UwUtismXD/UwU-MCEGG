# Use official OpenJDK 21 slim image as base
FROM openjdk:21-jdk-slim

# Install curl and jq
RUN apt-get update && apt-get install -y curl jq && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /minecraft-server

# Copy the server start script
COPY t.sh .

# Make the script executable
RUN chmod +x t.sh

# Copy entrypoint script
COPY entrypoint.sh .

# Make entrypoint executable
RUN chmod +x entrypoint.sh

# Expose Minecraft default port
EXPOSE 25565

# Set entrypoint to the entrypoint script
ENTRYPOINT ["./entrypoint.sh"]