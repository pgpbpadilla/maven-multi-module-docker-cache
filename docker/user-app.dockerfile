FROM maven:3-openjdk-11-slim as builder

WORKDIR /build

COPY pom.xml pom.xml
COPY common/pom.xml common/pom.xml
COPY user-app/pom.xml user-app/pom.xml

RUN mvn -q -ntp -B -pl common dependency:go-offline
COPY common common
RUN mvn -q -B -pl common install

COPY user-app user-app
RUN mvn -q -ntp -B -pl user-app dependency:go-offline
RUN mvn -o -q -ntp -B -pl user-app package

FROM adoptopenjdk/openjdk11:centos-jre

RUN mkdir -p /app
WORKDIR /app

COPY --from=builder /build/user-app/target/*.jar /app/userapp.jar

ENTRYPOINT ["java", "-jar", "userapp.jar"]
