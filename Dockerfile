# Stage 1: Build with Maven (Java 17)
FROM maven:3.8.8-openjdk-17 AS builder
WORKDIR /usr/src/demo
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy the Spring Boot JAR from the builder stage
COPY --from=builder /usr/src/demo/target/demo-0.0.1-SNAPSHOT.jar ./demo.jar

# Expose port your app will run on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","demo.jar"]
