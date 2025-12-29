# Stage 1: Build with Maven (Java 17)
FROM maven:3.8.6-openjdk-17 AS builder
WORKDIR /usr/src/demo
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy the built JAR
COPY --from=builder /usr/src/demo/target/demo-0.0.1-SNAPSHOT.jar ./demo.jar

# Default port
ENV SERVER_PORT=8080
EXPOSE $SERVER_PORT

# Run app with dynamic port
CMD ["sh", "-c", "java -jar demo.jar --server.port=$SERVER_PORT"]
