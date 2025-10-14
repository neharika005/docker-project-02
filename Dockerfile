# Stage 1: Build the Spring Boot app
FROM maven:3.9.4-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven wrapper and pom files
COPY mvnw pom.xml ./
COPY .mvn .mvn

# Copy source code
COPY src ./src

# Make Maven wrapper executable (if using it)
RUN chmod +x mvnw

# Package the Spring Boot app, skip tests
RUN mvn clean package -DskipTests

# Stage 2: Run the built JAR
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the backend port
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]

