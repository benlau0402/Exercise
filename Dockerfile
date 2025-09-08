# ---- Build stage ----
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copy only Gradle wrapper and build files first (better layer caching)
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle ./
RUN chmod +x gradlew
# Prime Gradle deps cache
RUN ./gradlew --no-daemon dependencies || true

# Now copy source and build a JAR
COPY src src
RUN ./gradlew --no-daemon clean jar

# ---- Runtime stage ----
FROM eclipse-temurin:21-jre
WORKDIR /app
# Copy the app JAR from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Run the console app
ENTRYPOINT ["java","-jar","/app/app.jar"]