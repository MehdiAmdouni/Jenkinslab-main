FROM openjdk:8u131-jre

MAINTAINER Richard Chesterwood "richard@inceptiontraining.co.uk"

COPY target/positionsimulator-0.0.1-SNAPSHOT.jar webapp.jar

CMD ["java","-jar","webapp.jar"]