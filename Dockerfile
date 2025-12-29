# Stage 1: Build with Maven
FROM maven:3.8-jdk-17 AS builder

# Copy project files
COPY . /usr/src/demo/
WORKDIR /usr/src/demo/

# Build the project
RUN mvn clean package -B

# Optional: check target folder
RUN ls -l /usr/src/demo/target/

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy the WAR file from the builder stage
COPY --from=builder /usr/src/demo/target/demo.war ./demo.war

# Copy start script
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

# Expose port your app will run on
EXPOSE 8080

# Run the application
CMD ["./start.sh"]
