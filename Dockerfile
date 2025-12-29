# Stage 1: Build with Maven and Java 17
FROM maven:3.8.7-eclipse-temurin-17 AS builder

# Copy project files
COPY . /usr/src/easybuggy/
WORKDIR /usr/src/easybuggy/

# Build the project
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy the WAR file from the builder stage
COPY --from=builder /usr/src/easybuggy/target/ROOT.war ./easybuggy.war

# Copy start script
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

# Expose application port
EXPOSE 8080

# Run the application
CMD ["./start.sh"]
