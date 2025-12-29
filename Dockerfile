# Stage 1: Build with Maven (Java 17)
FROM maven:3.9.4-eclipse-temurin-17 AS builder

# Set working directory inside the container
WORKDIR /usr/src/demo

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Build the Spring Boot JAR file (skip tests for faster builds)
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy

# Set working directory for the runtime container
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /usr/src/demo/target/demo-0.0.1-SNAPSHOT.jar ./demo.jar

# Expose port your app will run on
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "demo.jar"]
