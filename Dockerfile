FROM java:8

WORKDIR /

COPY target/hello-spring-apirest-0.1.0.jar hello-spring-apirest-0.1.0.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "hello-spring-apirest-0.1.0.jar"]