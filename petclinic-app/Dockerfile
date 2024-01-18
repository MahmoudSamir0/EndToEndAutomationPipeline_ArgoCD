FROM openjdk
VOLUME /tmp
# Add the JAR file and its original version to the image
ADD target/spring-petclinic-3.2.0-SNAPSHOT.jar /app.jar
EXPOSE 8080
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
