# syntax=docker/dockerfile:1

# ---- Build stage ----
# Multi-arch base image — Temurin publishes native arm64 and amd64 builds,
# so this stage builds correctly on either host architecture.
FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /usr/src/app

# Copy Gradle wrapper and build files first for better layer caching —
# dependency resolution only re-runs when these change, not on every
# source edit.
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./
COPY api api
COPY clients/java clients/java

RUN chmod +x gradlew && ./gradlew :api:shadowJar --no-daemon

# ---- Runtime stage ----
FROM eclipse-temurin:17-jre-jammy

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/api/build/libs/marquez-*.jar marquez.jar
COPY marquez.yml marquez.yml

EXPOSE 5000 5001

ENTRYPOINT ["java", "-jar", "marquez.jar", "server", "marquez.yml"]