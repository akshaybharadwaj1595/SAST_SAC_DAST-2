# Stage 1: Build with Maven (Java 17)
FROM maven:3.9.4-eclipse-temurin-17 AS builder

WORKDIR /usr/src/demo

# Copy pom.xml first for caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy all source files
COPY . .

# Build the project, skip tests if needed
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /usr/src/demo/target/demo-0.0.1-SNAPSHOT.jar ./demo.jar

# Copy start script
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

# Expose the port
EXPOSE 8080

# Run the application
CMD ["./start.sh"]
