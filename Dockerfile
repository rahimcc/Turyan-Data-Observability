# Native arm64 (or amd64 — this runs on whatever host builds it)
# JRE base image. Just wraps the already-published jar.
FROM eclipse-temurin:17-jre-jammy

WORKDIR /usr/src/app

# Pull the pre-built jar directly from Maven Central instead of compiling.
ARG MARQUEZ_VERSION=0.50.0
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
    && curl -fL -o marquez.jar \
       "https://repo1.maven.org/maven2/io/github/marquezproject/marquez-api/${MARQUEZ_VERSION}/marquez-api-${MARQUEZ_VERSION}.jar"

COPY marquez.yml .

EXPOSE 5000 5001
ENTRYPOINT ["java", "-jar", "marquez.jar", "server", "marquez.yml"]