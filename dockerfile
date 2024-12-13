# Build -> JDK
# Create a image for the application built -> JRE

# Use an official Maven image as the base image for building
FROM maven:3.8-openjdk-11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project definition (pom.xml) into the container
COPY pom.xml .

# Download the project dependencies
RUN mvn dependency:go-offline

# Copy the application source code into the container
COPY src ./src

# Build the Spring Boot application JAR target/*.jar
RUN mvn package

# Use an official OpenJDK runtime image as the base image
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Spring Boot JAR from the build stage into the container
COPY --from=build /app/target/*.jar app.jar

# Expose the port that the Spring Boot app will listen on
EXPOSE 8081

# Specify the command to run the Spring Boot app when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]


# #with existing jar file 
# # Base image ubuntu with jre installed 
# From openjdk:11.0.15-jre 
# # Copy jar in to base image 
# ADD target/*.jar app.jar 
# # set the startup job this server program - listening -> task is running 
# ENTRYPOINT ["java","-jar","app.jar"]

# #Declrative command
# # docker build -t vijaynvb/todoapimvr:1.0 pathtothedockerfile