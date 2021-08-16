FROM maven:3-openjdk-11-slim as builder

WORKDIR /build

# Copy the dependency specifications
COPY pom.xml pom.xml
COPY common/pom.xml common/pom.xml
COPY user-app/pom.xml user-app/pom.xml

# Resolve dependencies for `common` module, e.g., shared libraries
# Also build all the required projects needed by the common module.
# In this case, it will also resolve dependencies for the `root` module.
RUN mvn -q -ntp -B -pl common -am dependency:go-offline
# Copy full sources for `common` module
COPY common common
# Install the common module in the local Maven repo (`.m2`)
# This will also install the `root` module.
# See: `la -lat ~/.m2/repository/org/example/*/*`
RUN mvn -q -B -pl common install

# Resolve dependencies for the main application
RUN mvn -q -ntp -B -pl user-app -am dependency:go-offline
# Copy sources for main application
COPY user-app user-app
# Package the common and application modules together
RUN mvn -q -ntp -B -pl common,user-app package

RUN mkdir -p /jar-layers
WORKDIR /jar-layers
# Extract JAR layers
RUN java -Djarmode=layertools -jar /build/user-app/target/*.jar extract

FROM adoptopenjdk/openjdk11:centos-jre

RUN mkdir -p /app
WORKDIR /app

# Copy JAR layers, layers that change more often should go at the end
COPY --from=builder /jar-layers/dependencies/ ./
COPY --from=builder /jar-layers/spring-boot-loader/ ./
COPY --from=builder /jar-layers/snapshot-dependencies/ ./
COPY --from=builder /jar-layers/application/ ./

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
